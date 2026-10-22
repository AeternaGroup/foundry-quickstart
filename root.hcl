# Shared by every unit. State is kept beside each unit, so nothing here needs a cloud account.
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

# The modules declare which provider they need; the provider's settings come from here. The Docker
# provider reads DOCKER_HOST, so Podman works too.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {}
EOF
}
