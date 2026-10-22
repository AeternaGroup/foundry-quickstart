include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/AeternaFoundry/module_docker_image.git?ref=v4.6.0"
}

inputs = {
  images = {
    nginx = {
      name = "docker.io/library/nginx:1.27-alpine"
    }
  }
}
