data "aws_ssoadmin_instances" "this" {}

resource "aws_identitystore_user" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = var.display_name
  user_name    = var.user_name

  name {
    given_name  = var.name.given_name
    family_name = var.name.family_name
  }

  emails {
    value = var.emails[0].value
  }
}