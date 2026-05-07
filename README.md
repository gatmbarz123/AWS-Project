<<<<<<< HEAD
# AWS Project Architecture Showcase

This repository is a sanitized architecture showcase copied from three working DevOps repositories into one repo:

- `terraform/` — AWS infrastructure as code: networking, EKS, IAM, storage, security, DNS, databases, ECR, backups, and environment stacks.
- `helm-charts/` — reusable Helm parent chart for standard Kubernetes microservice deployment.
- `argo-cd/` — GitOps configuration with Argo CD ApplicationSets, cluster addons, app values, and deployment workflows.

Target personal repository: `https://github.com/gatmbarz123/AWS-Project.git`.

## Sanitization notice

All company-specific runtime values were replaced with default/example placeholders. The repository is intended to demonstrate architecture and delivery patterns, not to deploy a real production environment as-is.

Examples of sanitized values:

- AWS account IDs use `123456789012`.
- Domains use `example.com`.
- GitHub repository URLs point to this showcase repository or example owners.
- Secrets, ExternalSecret remote references, SSO users, emails, role ARNs, certificates, hosted zones, S3 buckets, SQS queues, WAF IDs, and generated Terraform artifacts were removed or replaced.

## Repository layout

```text
.
├── terraform/     # Infrastructure modules and multi-env/multi-region stacks
├── helm-charts/   # Reusable platform service Helm chart
├── argo-cd/       # GitOps/ApplicationSet configuration and workflows
└── docs/          # Architecture notes
```

## Important

Before using this for a real environment, replace all example placeholders with your own accounts, domains, certificates, secrets, remote state backend, and GitHub/AWS credentials.
=======
# AWS-Project
Demo for AWS/ IaC / GitOps Repo
>>>>>>> 99680b3966473a11a18c4cc38361cf9044d7143d
