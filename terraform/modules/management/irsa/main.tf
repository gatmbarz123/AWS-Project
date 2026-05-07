resource "aws_iam_role" "service_account_role" {
  name = var.name
  assume_role_policy = var.assume_role_policy != null ? var.assume_role_policy : templatefile("${var.policy_folder}/sa_assume_role_policy.json.tpl",
    {
      ACCOUNT_ID          = data.aws_caller_identity.current.account_id,
      EKS_OIDC_PROVIDER   = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", ""),
      SERVICEACCOUNT_PATH = var.service_account_path,
      PARTITION           = data.aws_partition.current.partition
  })
}

resource "aws_iam_role_policy" "service_account_policy" {
  for_each = { for i, policy in tolist(var.inline_policies) : i => policy }
  name     = "${var.name}-policy-${each.key}"
  role     = aws_iam_role.service_account_role.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  for_each   = { for i, policy in tolist(var.managed_policies) : i => policy }
  role       = aws_iam_role.service_account_role.name
  policy_arn = each.value
}

# For pod identity association
resource "aws_eks_pod_identity_association" "this" {
  count           = var.create_pod_identity ? 1 : 0
  cluster_name    = data.aws_eks_cluster.cluster.name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.service_account_role.arn
}