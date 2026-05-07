# Architecture Overview

## Flow

1. **Terraform** provisions the AWS foundation: network, EKS clusters, IAM/IRSA roles, storage, DNS, security controls, ECR, databases, and supporting services.
2. **Helm** provides a reusable parent chart for microservices, including Deployment, Service, Ingress, HPA, PDB, ConfigMap, ServiceAccount, Job/CronJob, and ExternalSecret templates.
3. **Argo CD** uses ApplicationSets and environment values to deploy cluster addons and application workloads across regions, environments, and clusters.
4. **GitHub Actions** shows example automation for Terraform plans/applies, Argo CD bootstrap, application deployment, and image promotion flows.

## Key patterns preserved

- Multi-region and multi-environment Terraform stack layout.
- Reusable Terraform modules separated from environment configuration.
- Multiple EKS cluster groups such as `web` and `python-ai`.
- GitOps separation between addons, app groups, and per-cluster values.
- Helm standardization for microservice runtime resources.
- IRSA-style service account annotations and External Secrets integration.
- Example CI/CD workflows for infrastructure and application operations.

## Sanitized/defaulted values

This showcase intentionally uses default placeholders:

- Account ID: `123456789012`
- Domains: `example.com`
- State buckets: `*-example-platform-tf-state`
- Secrets: `Application/example/default-secret`
- Certificates / WAF / Route53 IDs: zero/example IDs
- Emails: `user@example.com` or role-based example emails

These values are not intended to connect to a real company account.
