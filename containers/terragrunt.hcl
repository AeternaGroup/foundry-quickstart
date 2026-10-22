include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  colours = {
    first  = "blue"
    second = "green"
  }
}

dependency "image" {
  config_path = "../image"
}

terraform {
  source = "git::https://github.com/AeternaFoundry/module_docker_container.git?ref=v4.6.0"
}

# One map, one container per entry. Add an entry to add a container.
inputs = {
  containers = {
    first = {
      name  = "aeterna-quickstart-${local.colours.first}"
      image = dependency.image.outputs.images_image_id["nginx"]
      ports = [{ internal = 80, external = 8081 }]
      upload = [{
        file    = "/usr/share/nginx/html/index.html"
        content = "<body style=\"background:${local.colours.first}\"><h1>${title(local.colours.first)}</h1><p>Created by Aeterna IaC Foundry from one map entry.</p></body>"
      }]
    }
    second = {
      name  = "aeterna-quickstart-${local.colours.second}"
      image = dependency.image.outputs.images_image_id["nginx"]
      ports = [{ internal = 80, external = 8082 }]
      upload = [{
        file    = "/usr/share/nginx/html/index.html"
        content = "<body style=\"background:${local.colours.second}\"><h1>${title(local.colours.second)}</h1><p>Created by Aeterna IaC Foundry from one map entry.</p></body>"
      }]
    }
  }
}
