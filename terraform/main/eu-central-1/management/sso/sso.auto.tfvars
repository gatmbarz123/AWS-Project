sso_users = {
  "example_admin" = {
    user_name = "user@example.com"
  }
  "example_developer" = {
    user_name = "user@example.com"
  }
}

sso_groups = {
  "admins" = {
    display_name = "Admins"
    description  = "Example admins group"
  }
  "developers" = {
    display_name = "Developers"
    description  = "Example developers group"
  }
  "read_only" = {
    display_name = "ReadOnly"
    description  = "Example read-only group"
  }
}

sso_group_memberships = {
  "admins" = {
    member_id = ["example_admin"]
  }
  "developers" = {
    member_id = ["example_developer"]
  }
  "read_only" = {
    member_id = []
  }
}

permission_sets = {
  "admins" = {
    description        = "Example admin policy"
    managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
  "developers" = {
    description        = "Example developer policy"
    managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  }
  "read_only" = {
    description        = "Example read-only policy"
    managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

account_assignments = {
  "dev_admins" = {
    sso_group_id        = "admins"
    account_id          = "123456789012"
    permission_set_name = "admins"
  }
  "dev_developers" = {
    sso_group_id        = "developers"
    account_id          = "123456789012"
    permission_set_name = "developers"
  }
  "prod_read_only" = {
    sso_group_id        = "read_only"
    account_id          = "123456789012"
    permission_set_name = "read_only"
  }
}
