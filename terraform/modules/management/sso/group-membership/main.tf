data "aws_ssoadmin_instances" "this" {}

resource "aws_identitystore_group_membership" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = var.group_id
  member_id         = var.member_id
}