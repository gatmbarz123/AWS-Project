# Terraform Infrastructure

This folder contains the sanitized Terraform part of the `AWS-Project` architecture showcase.

It demonstrates how the platform infrastructure was split into reusable modules and environment-specific stacks across multiple AWS regions and accounts. All real account IDs, domains, state buckets, emails, secrets, SSO users, and ARNs were replaced with default/example values.

## What is included

- Multi-region AWS layout:
  - `eu-central-1`
  - `us-east-1`
  - `us-gov-west-1`
- Multi-environment layout:
  - `dev`
  - `qa`
  - `demo`
  - `staging`
  - `production`
  - `management`
  - `playground`
- Infrastructure components:
  - `network` — VPC and networking foundation
  - `compute` — EKS clusters and node group/Karpenter foundation
  - `iam` — IAM roles, IRSA, and access policies
  - `dns` — Route53 hosted zones and certificates
  - `database` — Aurora/RDS infrastructure
  - `storage` — S3 buckets and storage resources
  - `security` — CloudTrail, AWS Config, GuardDuty, WAF, Security Hub style controls
  - `ecr` — container repositories
  - `backup` — AWS Backup resources
  - `datadog` — monitoring integration example
  - `sso` — Identity Center/SSO example configuration
  - `ses` — email/domain verification example
  - `github-actions-runners` — self-hosted GitHub Actions runner example

## Repository structure

```text
terraform/
├── .github/workflows/
│   ├── 00-trigger-terraform.yaml
│   └── 01-run-envs-terraform.yaml
├── main/
│   ├── common/policies/              # Shared IAM/IRSA/policy templates
│   ├── eu-central-1/<environment>/    # Regional environment stacks
│   ├── us-east-1/<environment>/
│   └── us-gov-west-1/<environment>/
└── modules/                          # Reusable Terraform modules
    ├── compute/
    ├── database/
    ├── dns/
    ├── management/
    ├── network/
    ├── security/
    └── storage/
```

Each deployable stack follows this pattern:

```text
main/<region>/<environment>/<component>/
├── backend.tf
├── main.tf
├── variables.tf
├── versions.tf
└── <component>.auto.tfvars
```

Shared values are loaded from:

- `main/<region>/region.tfvars`
- `main/<region>/<environment>/env.tfvars`

## Sanitized defaults

This showcase is not connected to a real AWS account. Common defaults are:

- AWS account ID: `123456789012`
- Domain: `example.com`
- Terraform state buckets: `*-example-platform-tf-state`
- Hosted zone ID: `Z0000000000000`
- Email: `user@example.com`
- Placeholder ARNs such as `arn:aws:iam::123456789012:role/example-role`

Before deploying anywhere real, replace these with your own AWS accounts, domains, remote state backend, secrets, SSO identities, and role names.

## GitHub Actions workflows

The workflows were updated for the sanitized combined repo: `gatmbarz123/AWS-Project`.

### `00-trigger-terraform.yaml`

Runs automatically on pull requests and pushes to `main`.

What it does:

1. Detects changed paths under `main/<region>/<environment>/<component>`.
2. Builds a matrix of affected Terraform stacks.
3. Triggers `01-run-envs-terraform.yaml` for each changed stack.
4. Uses `secrets.EXAMPLE_GITHUB_TOKEN` as a placeholder token for cross-workflow triggering.

### `01-run-envs-terraform.yaml`

Runs by `workflow_dispatch`, either manually or from the trigger workflow.

Inputs:

- `environment` — environment folder to run, for example `dev` or `production`.
- `region` — AWS region folder, for example `eu-central-1`.
- `project` — component folder, for example `compute`, `network`, or `iam`.
- `apply` — `false` for plan only, `true` to apply.
- `pr_number` — optional PR number used for plan comments.

What it does:

1. Configures AWS credentials.
2. Runs `terraform init`.
3. Runs `terraform validate`.
4. Runs formatting checks.
5. Runs `terraform plan` using `../env.tfvars` and `../../region.tfvars`.
6. Writes the plan summary to the GitHub Actions summary.
7. Optionally comments the plan link on the PR.
8. Applies the plan only when `apply=true`.

## Manual example

```bash
cd terraform/main/eu-central-1/dev/compute
terraform init
terraform validate
terraform plan -var-file ../env.tfvars -var-file ../../region.tfvars
```

## Notes

- This folder is sanitized for architecture review.
- Generated files such as `.terraform/`, `.terraform.lock.hcl`, `terraform.tfstate*`, plans, and local outputs are intentionally excluded.
- The workflows are examples and require real AWS credentials, GitHub secrets, backend buckets, and IAM roles before use.
