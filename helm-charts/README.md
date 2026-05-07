# Helm Charts

A collection of Helm charts for deploying microservices in Kubernetes, with a focus on the platform-service-chart parent chart.

## Overview

This repository contains a parent Helm chart designed to standardize the deployment of microservices with common configurations for:
- Deployments
- Services
- Ingress (ALB)
- ConfigMaps
- External Secrets
- Pod Disruption Budgets
- Horizontal Pod Autoscaling
- Service Accounts

## Prerequisites

- Kubernetes 1.26+
- Helm 3.0+
- AWS EKS cluster
- External Secrets Operator installed in the cluster


## Configuration

The following table lists the configurable parameters and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Environment name | `dev` |
| `global.region` | AWS region | `eu-central-1` |
| `global.repo` | Container repository | `example.repo` |
| `global.example_private_hostname` | Private base hostname | `dev.internal.example.com` |
| `global.example_public_hostname` | Public base hostname | `example.com` |

### Deployment Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `deployment.enabled` | Enable deployment | `true` |
| `deployment.replicas` | Number of replicas | `1` |
| `deployment.image.tag` | Image tag | `1.0.0` |
| `deployment.deploymentStrategy` | Deployment strategy | `RollingUpdate` |

### Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.enabled` | Enable service | `true` |
| `service.targetPort` | Container port | `80` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.internet` | Internet-facing ALB | `true` |
| `ingress.path` | Ingress path | `/` |

## Features

### External Secrets Integration
The chart supports automatic secret management using External Secrets Operator, allowing you to fetch secrets from AWS Secrets Manager.

### Automatic Scaling
Supports horizontal pod autoscaling based on CPU and memory metrics.

### Pod Disruption Budget
Ensures high availability during cluster operations by maintaining minimum available pods.

### AWS Integration
- Automatic ALB provisioning
- IAM roles for service accounts
- AWS Secrets Manager integration

## Example Values File

See `values-temp.yaml` for a complete example of configuration options.

## Debug 
```
helm intall --dry-run --debug test ./chart -f values-temp.yaml
```