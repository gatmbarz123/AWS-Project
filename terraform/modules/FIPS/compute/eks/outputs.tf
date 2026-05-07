output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}
output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}