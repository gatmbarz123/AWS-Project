# Argo CD GitOps Configuration

This folder contains the sanitized Argo CD/GitOps part of the `AWS-Project` architecture showcase.

It demonstrates how Kubernetes platform addons and application workloads are deployed with Argo CD ApplicationSets across multiple environments, AWS regions, and EKS cluster groups. All real company values were replaced with default/example values.

## What is included

- Argo CD Helm values per environment.
- ApplicationSet definitions for cluster addons and application groups.
- Per-cluster Helm values for the `web` and `python-ai` EKS cluster groups.
- Cluster addon configuration examples:
  - AWS Load Balancer Controller
  - Karpenter
  - External Secrets Operator
  - External DNS private/public
  - Datadog
  - kube-prometheus-stack
  - metrics-server
  - reloader
  - node pools / GPU addons
- Application workload value examples:
  - `web`
  - `web-api`
  - `db-migrations`
  - `db-migrations-api`
  - `python-ai-gpu`
  - `python-ai-non-gpu`
  - `python-ai-api-non-gpu`
  - `python-ai-edge-non-gpu`
  - `ec2-scheduler`
- GitHub Actions workflows for Argo CD bootstrap, app-of-apps deployment, and image promotion examples.

## Repository structure

```text
argo-cd/
├── .github/workflows/
│   ├── 00-new-argocd-helm-install.yaml
│   ├── 01-deploy-karpenter-app.yaml
│   ├── 02-deploy-cluster-addons-app.yaml
│   ├── 03-deploy-cluster-secret-stores.yaml
│   ├── 04-deploy-web-apps.yaml
│   ├── 05-deploy-gpu-addons.yaml
│   ├── 06-deploy-python-ai-gpu-apps.yaml
│   ├── 07-deploy-python-ai-non-gpu-apps.yaml
│   ├── 08-deploy-python-ai-api-non-gpu-apps.yaml
│   ├── 09-deploy-web-api-apps.yaml
│   ├── 10-deploy-ec2-scheduler.yaml
│   ├── 11-deploy-python-ai-edge-non-gpu-apps.yaml
│   ├── promote-to-demo-euc1.yaml
│   ├── promote-to-staging-euc1.yaml
│   ├── promote-to-prod-euc1.yaml
│   └── services.json
└── regions/
    ├── eu-central-1/environments/{dev,demo,staging,production}/
    ├── us-east-1/environments/production/
    └── us-gov-west-1/environments/dev/
```

Environment folders follow this pattern:

```text
regions/<region>/environments/<environment>/
├── argocd/
│   ├── values.yaml                 # Argo CD chart values
│   └── applicationsets/            # ApplicationSet manifests
├── cluster-addons/                 # Shared addon values/charts
└── clusters/
    ├── global-values.yaml          # Shared Helm globals for the environment
    ├── web/values/apps/...         # App values for web cluster workloads
    ├── web/values/cluster-addons/...
    ├── python-ai/values/apps/...   # App values for python-ai workloads
    └── python-ai/values/cluster-addons/...
```

## Sanitized defaults

This is an architecture showcase, not a ready-to-deploy production repository.

Common placeholder values:

- Git repo URL: `https://github.com/gatmbarz123/AWS-Project.git`
- AWS account ID: `123456789012`
- Domain: `example.com`
- Secret remote reference: `Application/example/default-secret`
- Certificate/WAF/Route53 IDs: zero/example IDs
- Email: `user@example.com`
- Image repositories: example ECR/repo values

Before using this in a real environment, replace placeholders with your own GitHub repo, AWS accounts, domains, certificates, cluster names, ECR repos, secrets, and environment variables.

## ApplicationSet groups

The `argocd/applicationsets/` folders define app-of-apps style deployments for:

- `karpenter-apps.yaml` — Karpenter controller/node class/node pool resources.
- `cluster-addons.yaml` — shared cluster addons such as metrics, External DNS, External Secrets, monitoring, and controllers.
- `cluster-secret-stores.yaml` — External Secrets `SecretStore` / `ClusterSecretStore` resources.
- `gpu-addons.yaml` — GPU-specific cluster addons.
- `default-node-pools-apps.yaml` — default Karpenter node pools.
- `web-cluster-applications.yaml` — `web` workloads.
- `web-api-cluster-applications.yaml` — `web-api` workloads.
- `python-ai-gpu-applications.yaml` — GPU AI workloads.
- `python-ai-non-gpu-applications.yaml` — non-GPU AI workloads.
- `python-ai-api-non-gpu-applications.yaml` — AI API workloads.
- `python-ai-edge-non-gpu-applications.yaml` — edge/non-GPU AI workloads.
- `ec2-scheduler-applications.yaml` — EC2 scheduler workload.

## GitHub Actions workflows

The workflows were updated for the sanitized combined repo and use `https://github.com/gatmbarz123/AWS-Project.git` as the example source repo.

### Bootstrap workflow

#### `00-new-argocd-helm-install.yaml`

Installs or upgrades the Argo CD Helm chart in the target EKS cluster.

It uses GitHub environment variables/secrets such as:

- `vars.AWS_REGION`
- `vars.ENVIRONMENT`
- `vars.AWS_WEB_CLUSTER_NAME`
- `vars.AWS_PYTHON_AI_CLUSTER_NAME`
- `vars.ARGOCD_URL`
- `secrets.AWS_ACCESS_KEY_ID`
- `secrets.AWS_SECRET_ACCESS_KEY`
- `secrets.EXAMPLE_ARGOCD_READONLY_TOKEN`
- `secrets.EXAMPLE_HELM_CHART_READONLY_TOKEN`
- `secrets.EXAMPLE_SAML_ASSERTION_URL`
- `secrets.EXAMPLE_ARGOCD_APP_CA_DATA`

### ApplicationSet deployment workflows

These workflows apply specific ApplicationSet YAML files from:

```text
regions/${{ vars.AWS_REGION }}/environments/${{ vars.ENVIRONMENT }}/argocd/applicationsets
```

| Workflow | Purpose |
| --- | --- |
| `01-deploy-karpenter-app.yaml` | Applies Karpenter ApplicationSets. |
| `02-deploy-cluster-addons-app.yaml` | Applies shared cluster addon ApplicationSets. |
| `03-deploy-cluster-secret-stores.yaml` | Applies External Secrets store ApplicationSets. |
| `04-deploy-web-apps.yaml` | Applies `web` application ApplicationSets. |
| `05-deploy-gpu-addons.yaml` | Applies GPU addon ApplicationSets. |
| `06-deploy-python-ai-gpu-apps.yaml` | Applies `python-ai-gpu` workloads. |
| `07-deploy-python-ai-non-gpu-apps.yaml` | Applies `python-ai-non-gpu` workloads. |
| `08-deploy-python-ai-api-non-gpu-apps.yaml` | Applies `python-ai-api-non-gpu` workloads. |
| `09-deploy-web-api-apps.yaml` | Applies `web-api` workloads. |
| `10-deploy-ec2-scheduler.yaml` | Applies EC2 scheduler workload. |
| `11-deploy-python-ai-edge-non-gpu-apps.yaml` | Applies `python-ai-edge-non-gpu` workloads. |

### Promotion workflows

The promotion workflows are example CI/CD flows that read image tags from lower environment values files, copy images between ECR repositories, and open/update PRs with the promoted image tag.

| Workflow | Purpose |
| --- | --- |
| `promote-to-staging-euc1.yaml` | Promotes an image tag from dev to staging in `eu-central-1`. |
| `promote-to-demo-euc1.yaml` | Promotes an image tag toward demo in `eu-central-1`. |
| `promote-to-prod-euc1.yaml` | Promotes an image tag toward production in `eu-central-1`. |
| `services.json` | Maps services to cluster groups for the promotion workflows. |

## Manual example

```bash
cd argo-cd
kubectl apply -f regions/eu-central-1/environments/dev/argocd/applicationsets/web-cluster-applications.yaml
```

## Notes

- This folder is sanitized for architecture review.
- Workflow secrets and variables are examples and must be replaced before real use.
- The ApplicationSet repo URLs point to the combined showcase repo; adjust paths/repo URLs if splitting back into separate repos.
- Secret names and `remoteRef.key` values are placeholders and do not reference real secret stores.
