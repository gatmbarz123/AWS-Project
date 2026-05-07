module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  enable_irsa            = true
  irsa_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_name           = "${var.prefix}-eks"

  create_node_iam_role    = false
  node_iam_role_arn       = module.eks.eks_managed_node_groups["karpenter"].iam_role_arn
  create_access_entry     = false
  enable_spot_termination = var.enable_karpenter_spot_termination

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:${var.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}