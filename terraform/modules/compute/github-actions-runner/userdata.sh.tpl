#!/bin/bash
set -euo pipefail

REGION="${REGION}"
GITHUB_CONFIG_URL="${GITHUB_CONFIG_URL}"
RUNNER_LABELS="${RUNNER_LABELS}"
GITHUB_APP_ID="${GITHUB_APP_ID}"
GITHUB_APP_INSTALLATION_ID="${GITHUB_APP_INSTALLATION_ID}"
GITHUB_APP_PRIVATE_KEY_SECRET_ARN="${GITHUB_APP_PRIVATE_KEY_SECRET_ARN}"
LOG_GROUP="${LOG_GROUP}"
PREFIX="${PREFIX}"
RUNNER_VERSION="2.323.0"
RUNNER_HOME="/home/runner/actions-runner"

exec > >(tee /var/log/runner-setup.log) 2>&1

# ── IMDSv2 instance identity ─────────────────────────────────────────────────
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

RUNNER_NAME="$PREFIX-runner-$INSTANCE_ID"

# ── CloudWatch Agent ─────────────────────────────────────────────────────────
yum install -y amazon-cloudwatch-agent jq git

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<CWEOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/runner-setup.log",
            "log_group_name": "$LOG_GROUP",
            "log_stream_name": "$INSTANCE_ID/setup"
          },
          {
            "file_path": "$RUNNER_HOME/_diag/*.log",
            "log_group_name": "$LOG_GROUP",
            "log_stream_name": "$INSTANCE_ID/runner"
          }
        ]
      }
    }
  }
}
CWEOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# ── Helper: base64url-encode (no padding) ────────────────────────────────────
b64url() {
  base64 -w 0 | tr '+/' '-_' | tr -d '='
}

# ── Helper: generate a GitHub App JWT ────────────────────────────────────────
# Returns a signed JWT valid for 10 minutes.
generate_github_app_jwt() {
  local app_id="$1"
  local private_key_file="$2"

  local now
  now=$(date +%s)
  local iat=$(( now - 60 ))   # issued 60s ago to allow clock skew
  local exp=$(( now + 600 ))  # expires in 10 minutes

  local header payload header_b64 payload_b64 sig_input sig

  header='{"alg":"RS256","typ":"JWT"}'
  payload="{\"iat\":$iat,\"exp\":$exp,\"iss\":\"$app_id\"}"

  header_b64=$(printf '%s' "$header"  | b64url)
  payload_b64=$(printf '%s' "$payload" | b64url)

  sig_input="$header_b64.$payload_b64"

  sig=$(printf '%s' "$sig_input" | \
    openssl dgst -sha256 -sign "$private_key_file" | b64url)

  printf '%s' "$sig_input.$sig"
}

# ── Helper: get a fresh GitHub App installation access token ─────────────────
get_installation_token() {
  local jwt="$1"
  local installation_id="$2"

  curl -sf -X POST \
    -H "Authorization: Bearer $jwt" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/app/installations/$installation_id/access_tokens" \
    | jq -r '.token'
}

# ── Fetch GitHub App private key from Secrets Manager ────────────────────────
PRIVATE_KEY_FILE=$(mktemp /tmp/gh-app-key.XXXXXX.pem)
chmod 600 "$PRIVATE_KEY_FILE"

aws secretsmanager get-secret-value \
  --region "$REGION" \
  --secret-id "$GITHUB_APP_PRIVATE_KEY_SECRET_ARN" \
  --query 'SecretString' \
  --output text | sed 's/\\n/\n/g' > "$PRIVATE_KEY_FILE"

# ── Generate JWT and obtain installation access token ────────────────────────
JWT=$(generate_github_app_jwt "$GITHUB_APP_ID" "$PRIVATE_KEY_FILE")
INSTALLATION_TOKEN=$(get_installation_token "$JWT" "$GITHUB_APP_INSTALLATION_ID")

# ── Obtain runner registration token ─────────────────────────────────────────
URL_PATH=$(echo "$GITHUB_CONFIG_URL" | sed 's|https://github\.com/||')
SLASH_COUNT=$(echo "$URL_PATH" | tr -cd '/' | wc -c)

if [ "$SLASH_COUNT" -ge 1 ]; then
  # repo-level runner
  REGISTRATION_API="https://api.github.com/repos/$URL_PATH/actions/runners/registration-token"
  REMOVAL_API="https://api.github.com/repos/$URL_PATH/actions/runners/remove-token"
else
  # org-level runner
  REGISTRATION_API="https://api.github.com/orgs/$URL_PATH/actions/runners/registration-token"
  REMOVAL_API="https://api.github.com/orgs/$URL_PATH/actions/runners/remove-token"
fi

REGISTRATION_TOKEN=$(curl -sf -X POST \
  -H "Authorization: token $INSTALLATION_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "$REGISTRATION_API" | jq -r '.token')

# Wipe key from disk once tokens are obtained
rm -f "$PRIVATE_KEY_FILE"

# ── Install runner ───────────────────────────────────────────────────────────
useradd -m runner 2>/dev/null || true

mkdir -p "$RUNNER_HOME"

curl -sfL -o /tmp/runner.tar.gz \
  "https://github.com/actions/runner/releases/download/v$${RUNNER_VERSION}/actions-runner-linux-x64-$${RUNNER_VERSION}.tar.gz"

tar xzf /tmp/runner.tar.gz -C "$RUNNER_HOME"
rm /tmp/runner.tar.gz
chown -R runner:runner /home/runner

# ── Install runner dependencies (AL2023 not recognised by installdependencies.sh) ──
yum install -y --allowerasing libicu openssl-libs krb5-libs zlib libstdc++ gnupg2 postgresql15

# ── Install Docker ────────────────────────────────────────────────────────────
yum install -y docker
systemctl enable --now docker
usermod -aG docker runner

# ── Install Erlang/Elixir build dependencies (required by mise) ───────────────
yum install -y \
  gcc gcc-c++ make autoconf automake libtool \
  openssl-devel ncurses-devel \
  tar gzip bzip2 xz

# ── Configure runner ─────────────────────────────────────────────────────────
cd "$RUNNER_HOME"
sudo -u runner ./config.sh \
  --url "$GITHUB_CONFIG_URL" \
  --token "$REGISTRATION_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --unattended \
  --replace

# ── Configure SSH to use port 443 for github.com (port 22 blocked) ───────────
mkdir -p /home/runner/.ssh
cat >> /home/runner/.ssh/config <<'SSHEOF'
Host github.com
    Hostname ssh.github.com
    Port 443
SSHEOF
chmod 600 /home/runner/.ssh/config

# Add github.com host key for port 443 to known_hosts
ssh-keyscan -p 443 ssh.github.com >> /home/runner/.ssh/known_hosts
chmod 644 /home/runner/.ssh/known_hosts
chown -R runner:runner /home/runner/.ssh

# ── Install and start runner service ─────────────────────────────────────────
./svc.sh install runner
./svc.sh start

# ── Deregister runner on instance shutdown ───────────────────────────────────
# Writes a helper script that re-generates a fresh installation token at
# shutdown time (the registration token from startup will have expired).
cat > /usr/local/bin/github-runner-deregister.sh <<DEREGEOF
#!/bin/bash
set -euo pipefail

REGION="$REGION"
GITHUB_APP_ID="$GITHUB_APP_ID"
GITHUB_APP_INSTALLATION_ID="$GITHUB_APP_INSTALLATION_ID"
GITHUB_APP_PRIVATE_KEY_SECRET_ARN="$GITHUB_APP_PRIVATE_KEY_SECRET_ARN"
REMOVAL_API="$REMOVAL_API"
RUNNER_HOME="$RUNNER_HOME"

b64url() { base64 -w 0 | tr '+/' '-_' | tr -d '='; }

PRIVATE_KEY_FILE=\$(mktemp /tmp/gh-app-key.XXXXXX.pem)
chmod 600 "\$PRIVATE_KEY_FILE"

aws secretsmanager get-secret-value \
  --region "\$REGION" \
  --secret-id "\$GITHUB_APP_PRIVATE_KEY_SECRET_ARN" \
  --query 'SecretString' --output text | sed 's/\\n/\n/g' > "\$PRIVATE_KEY_FILE"

NOW=\$(date +%s)
IAT=\$(( NOW - 60 ))
EXP=\$(( NOW + 600 ))
HEADER='{"alg":"RS256","typ":"JWT"}'
PAYLOAD="{\"iat\":\$IAT,\"exp\":\$EXP,\"iss\":\"\$GITHUB_APP_ID\"}"
H=\$(printf '%s' "\$HEADER"  | b64url)
P=\$(printf '%s' "\$PAYLOAD" | b64url)
SIG=\$(printf '%s' "\$H.\$P" | openssl dgst -sha256 -sign "\$PRIVATE_KEY_FILE" | b64url)
JWT="\$H.\$P.\$SIG"

INSTALLATION_TOKEN=\$(curl -sf -X POST \
  -H "Authorization: Bearer \$JWT" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/app/installations/\$GITHUB_APP_INSTALLATION_ID/access_tokens" \
  | jq -r '.token')

rm -f "\$PRIVATE_KEY_FILE"

REMOVE_TOKEN=\$(curl -sf -X POST \
  -H "Authorization: token \$INSTALLATION_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "\$REMOVAL_API" | jq -r '.token')

cd "\$RUNNER_HOME"
sudo -u runner ./config.sh remove --token "\$REMOVE_TOKEN"
DEREGEOF

chmod +x /usr/local/bin/github-runner-deregister.sh

cat > /etc/systemd/system/github-runner-deregister.service <<SVCEOF
[Unit]
Description=Deregister GitHub Actions Runner on shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=/usr/local/bin/github-runner-deregister.sh
TimeoutStopSec=60

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable github-runner-deregister.service
systemctl start github-runner-deregister.service
