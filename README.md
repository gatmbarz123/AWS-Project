# AWS Platform Architecture Showcase

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![ArgoCD](https://img.shields.io/badge/Argo_CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)

> A sanitized copy of a real production AWS/Kubernetes platform, consolidated from three working repositories to demonstrate hands-on experience in cloud infrastructure, GitOps, and platform engineering.

---

## Table of Contents

- [About This Repository](#about-this-repository)
- [Technology Stack](#technology-stack)
- [High-Level Architecture](#high-level-architecture)
- [Repository Layout](#repository-layout)
- [Skills Demonstrated](#skills-demonstrated)
- [Terraform — Infrastructure as Code](#terraform--infrastructure-as-code)
- [Helm Charts — Kubernetes Packaging](#helm-charts--kubernetes-packaging)
- [Argo CD — GitOps Delivery](#argo-cd--gitops-delivery)
- [Sanitization Notice](#sanitization-notice)

---

## About This Repository

This repository is a **portfolio showcase** built from real DevOps repositories I worked on in production.

Three originally separate repositories — infrastructure, Helm charts, and GitOps — were merged into one public repo so that hiring teams can review the full delivery stack in a single place. All company-specific values (account IDs, domains, secrets, ARNs) have been replaced with safe placeholder defaults.

The goal is to show **what I actually built and how I built it** — not a tutorial, not a toy project.

---

## Technology Stack

| Layer | Tools |
|---|---|
| Cloud Provider | AWS (multi-region, multi-account) |
| Infrastructure as Code | Terraform (modules + environment stacks) |
| Container Orchestration | Kubernetes on EKS |
| GitOps | Argo CD + ApplicationSets |
| Kubernetes Packaging | Helm (custom parent chart) |
| Node Autoscaling | Karpenter |
| Secret Management | AWS Secrets Manager + External Secrets Operator |
| Ingress | AWS Load Balancer Controller (ALB) |
| DNS | Route53 (private + public hosted zones) |
| TLS | AWS Certificate Manager (ACM) |
| Monitoring | Datadog, kube-prometheus-stack, metrics-server |
| Database | Aurora/RDS |
| Storage | S3 |
| Container Registry | ECR |
| Security | GuardDuty, AWS Config, CloudTrail, Security Hub, WAF |
| Identity | IAM, IRSA, AWS IAM Identity Center (SSO) |
| CI/CD | GitHub Actions |

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Actions CI/CD                     │
│  ┌──────────────┐   ┌──────────────┐   ┌─────────────────────┐ │
│  │  Terraform   │   │  Argo CD     │   │  Image Promotion    │ │
│  │  Plan/Apply  │   │  Bootstrap   │   │  (dev→stg→prod)     │ │
│  └──────┬───────┘   └──────┬───────┘   └──────────┬──────────┘ │
└─────────┼──────────────────┼──────────────────────┼────────────┘
          │                  │                       │
          ▼                  ▼                       ▼
┌─────────────────┐  ┌───────────────┐      ┌───────────────┐
│  AWS Foundation │  │    Argo CD    │      │     ECR       │
│  ─────────────  │  │  (GitOps)     │      │  (Container   │
│  VPC / Subnets  │  │               │      │   Registry)   │
│  EKS Clusters   │  │  Watches Git  │      └───────┬───────┘
│  IAM / IRSA     │  │  Auto-syncs   │              │
│  Route53 / ACM  │  │  ApplicationS │              │
│  RDS Aurora     │  │  ets          │              │
│  S3 / ECR       │  └──────┬────────┘              │
│  Security Stack │         │                       │
└─────────────────┘         ▼                       │
                   ┌────────────────────────────────┴──┐
                   │         EKS Clusters              │
                   │  ┌──────────────┐ ┌────────────┐  │
                   │  │  web cluster │ │ python-ai  │  │
                   │  │              │ │  cluster   │  │
                   │  │  Helm Apps   │ │ (GPU/CPU)  │  │
                   │  │  + Addons    │ │            │  │
                   │  └──────────────┘ └────────────┘  │
                   │                                   │
                   │  Cluster Addons (per cluster):    │
                   │  Karpenter · ALB Controller       │
                   │  External Secrets · External DNS  │
                   │  Datadog · Prometheus · Reloader  │
                   └───────────────────────────────────┘
```

### Delivery Flow

1. **Terraform** provisions the AWS foundation: VPC, EKS clusters, IAM/IRSA roles, Route53, ACM, RDS, S3, ECR, and the full security stack.
2. **GitHub Actions** triggers Terraform plans on PRs and applies on merge. A matrix build detects which stacks changed and runs only those.
3. **Argo CD** is bootstrapped into the EKS clusters via a GitHub Actions workflow and Helm. From that point, it self-manages via ApplicationSets.
4. **ApplicationSets** drive the deployment of cluster addons (Karpenter, ALB Controller, External Secrets, Datadog, etc.) and application workloads across environments and regions.
5. **Helm charts** provide a standardized template (Deployment, Service, Ingress, HPA, PDB, ExternalSecret, ConfigMap) reused by every microservice.
6. **Promotion workflows** read image tags from lower-environment values files, copy images between ECR repos, and open PRs with the promoted tag.

---

## Repository Layout

```
.
├── terraform/          # AWS infrastructure — modules and multi-env/multi-region stacks
├── helm-charts/        # Reusable Helm parent chart for Kubernetes microservices
├── argo-cd/            # GitOps configuration — ApplicationSets, addons, app values
└── docs/               # Architecture notes
```

---

## Skills Demonstrated

| Area | What You Can See Here |
|---|---|
| **IaC Design** | Terraform split into reusable modules + per-region/env stacks; remote state; shared tfvars pattern |
| **Multi-region / Multi-env** | 3 AWS regions × 7 environments (dev, qa, demo, staging, prod, mgmt, playground) |
| **EKS Platform** | EKS cluster modules, Karpenter node pools, GPU node groups, IRSA wiring |
| **GitOps** | Argo CD ApplicationSets managing addons and workloads across clusters without manual kubectl |
| **Secret Management** | External Secrets Operator pulling from AWS Secrets Manager; IRSA-scoped access |
| **Helm Standardization** | One parent chart for all microservices; environment-specific values files |
| **Security** | GuardDuty, Config, CloudTrail, Security Hub, WAF — all provisioned via Terraform modules |
| **CI/CD** | GitHub Actions workflows for Terraform, Argo CD bootstrap, and image promotion pipelines |
| **Observability** | Datadog and kube-prometheus-stack deployed as cluster addons via GitOps |
| **Networking** | VPC design, private/public Route53 zones, ACM, ALB ingress |

---

## Terraform — Infrastructure as Code

The `terraform/` folder demonstrates how a production AWS platform is split into reusable modules and environment-specific stacks.

### Regions and Environments

| | `eu-central-1` | `us-east-1` | `us-gov-west-1` |
|---|:---:|:---:|:---:|
| dev | yes | | yes |
| qa | yes | | |
| demo | yes | | |
| staging | yes | | |
| production | yes | yes | |
| management | yes | | |
| playground | yes | | |

### Infrastructure Modules

| Module | What It Provisions |
|---|---|
| `network` | VPC, subnets, NAT gateways, routing |
| `compute` | EKS clusters, managed node groups, Karpenter, self-hosted GitHub Actions runners |
| `iam` | IAM roles, IRSA service account roles, access policies |
| `dns` | Route53 private/public hosted zones, ACM certificates, zone associations |
| `database` | Aurora/RDS clusters |
| `storage` | S3 buckets |
| `security` | CloudTrail, GuardDuty, AWS Config, Security Hub, WAF |
| `management/sso` | IAM Identity Center (SSO) permission sets |
| `management/datadog` | Datadog AWS integration |
| `management/ses` | SES domain/email verification |
| `backup` | AWS Backup vaults and plans |
| `ecr` | Container repositories |
| `FIPS/kms` | KMS keys with FIPS-compliant configuration |

### Stack Layout Pattern

Each deployable component follows a consistent layout:

```
terraform/main/<region>/<environment>/<component>/
├── backend.tf           # Remote state configuration
├── main.tf              # Module call
├── variables.tf
├── versions.tf
└── <component>.auto.tfvars
```

Shared values cascade from region → environment level:

```
main/<region>/region.tfvars
main/<region>/<environment>/env.tfvars
```

### CI/CD — GitHub Actions

| Workflow | Trigger | Purpose |
|---|---|---|
| `00-trigger-terraform.yaml` | Push / PR | Detects changed stacks, builds a matrix, triggers the run workflow for each |
| `01-run-envs-terraform.yaml` | `workflow_dispatch` | `init` → `validate` → `fmt` → `plan` (→ `apply` on merge) |

Plans are posted as PR comments. Apply only runs when explicitly triggered with `apply=true`.

```bash
# Local example
cd terraform/main/eu-central-1/dev/compute
terraform init
terraform plan -var-file ../env.tfvars -var-file ../../region.tfvars
```

---

## Helm Charts — Kubernetes Packaging

The `helm-charts/` folder contains a reusable **parent Helm chart** that standardizes how every microservice is deployed on the platform.

Instead of each team writing their own manifests, they provide a values file — the chart handles the rest.

### What the Chart Generates

| Template | Description |
|---|---|
| `Deployment` | Configurable replicas, image, strategy, resource limits |
| `Service` | ClusterIP service wired to the Deployment |
| `Ingress` | ALB ingress with internet/internal toggle |
| `HPA` | Horizontal Pod Autoscaler on CPU + memory |
| `PodDisruptionBudget` | Minimum availability during node operations |
| `ExternalSecret` | Pulls secrets from AWS Secrets Manager |
| `ConfigMap` | Environment-level configuration injection |
| `ServiceAccount` | IRSA-annotated service account |

### Key Configuration Options

| Parameter | Purpose |
|---|---|
| `global.environment` | Selects the environment tier |
| `global.region` | AWS region |
| `global.repo` | Container image repository base |
| `deployment.replicas` | Replica count |
| `deployment.image.tag` | Image version |
| `ingress.internet` | `true` = public ALB, `false` = internal ALB |
| `hpa.enabled` | Enable/disable autoscaling |

### Supported Environments

The chart ships with pre-configured values files for:
- `values-govcloud-dev.yaml` — GovCloud development
- `values-govcloud-prod.yaml` — GovCloud production
- `values-temp.yaml` — generic template/example

```bash
# Dry-run to preview rendered manifests
helm install --dry-run --debug test ./chart -f values-temp.yaml
```

---

## Argo CD — GitOps Delivery

The `argo-cd/` folder shows how Argo CD ApplicationSets manage the full deployment lifecycle — cluster addons and application workloads — across multiple regions and environments with no manual `kubectl apply`.

### How It Works

1. Argo CD is installed into each EKS cluster using a Helm-based GitHub Actions bootstrap workflow.
2. **ApplicationSets** are applied per environment. Each ApplicationSet watches this Git repo and automatically creates/updates/deletes Argo CD Applications as values files change.
3. **Cluster addons** (controllers, monitoring, autoscalers) and **application workloads** are managed as separate ApplicationSet groups so they can be deployed and rolled back independently.

### ApplicationSet Groups

| ApplicationSet | What It Manages |
|---|---|
| `karpenter-apps` | Karpenter controller, node classes, and node pools |
| `cluster-addons` | ALB Controller, External DNS, External Secrets, metrics-server, Datadog, Prometheus, reloader |
| `cluster-secret-stores` | `SecretStore` / `ClusterSecretStore` resources for External Secrets |
| `gpu-addons` | GPU-specific node drivers and device plugins |
| `web-cluster-applications` | `web` microservice workloads |
| `web-api-cluster-applications` | `web-api` microservice workloads |
| `python-ai-gpu-applications` | GPU AI inference workloads |
| `python-ai-non-gpu-applications` | CPU AI workloads |
| `python-ai-api-non-gpu-applications` | AI API tier workloads |
| `python-ai-edge-non-gpu-applications` | Edge AI workloads |
| `ec2-scheduler-applications` | EC2 scheduler (cost optimization) |

### Environment Structure

```
argo-cd/regions/<region>/environments/<environment>/
├── argocd/
│   ├── values.yaml                  # Argo CD Helm values for this environment
│   └── applicationsets/             # ApplicationSet manifests (one per workload group)
├── cluster-addons/                  # Addon Helm values
└── clusters/
    ├── global-values.yaml           # Shared globals for all clusters in this environment
    ├── web/values/apps/             # Per-service Helm values for the web cluster
    ├── web/values/cluster-addons/
    ├── python-ai/values/apps/       # Per-service Helm values for the AI cluster
    └── python-ai/values/cluster-addons/
```

### CI/CD — GitHub Actions

| Workflow | Purpose |
|---|---|
| `00-new-argocd-helm-install.yaml` | Bootstrap: installs/upgrades Argo CD via Helm into EKS |
| `01` – `11` deploy workflows | Apply specific ApplicationSet YAML files to the cluster |
| `promote-to-staging-euc1.yaml` | Reads image tag from dev, copies ECR image, opens a PR to staging |
| `promote-to-demo-euc1.yaml` | Same flow toward demo |
| `promote-to-prod-euc1.yaml` | Same flow toward production |

The promotion workflows provide a fully automated **dev → staging → production** image promotion pipeline driven by PRs, with the Git repo as the single source of truth.

---

## Sanitization Notice

This repository was sanitized before publishing. All real company values were replaced with safe defaults:

| What | Placeholder Used |
|---|---|
| AWS account IDs | `123456789012` |
| Domains | `example.com` |
| Terraform state buckets | `*-example-platform-tf-state` |
| Secrets / SSM paths | `Application/example/default-secret` |
| Certificate / WAF / Route53 IDs | `Z0000000000000` / zero IDs |
| Emails | `user@example.com` |
| Role ARNs | `arn:aws:iam::123456789012:role/example-role` |

The code is intended to demonstrate **architecture and delivery patterns**. It is not designed to be deployed to a real AWS account without replacing all placeholders with real values.
