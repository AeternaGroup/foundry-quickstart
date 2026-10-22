# Aeterna IaC Foundry quickstart

**Stop writing modules. Start writing inputs.**

This is a short example of how Aeterna's modules are structured, the input and output shape is consistent across all providers. The same structure can be used for Azure, AWS, GCP or any of our other [supported providers](https://aeternaltd.net/foundry/catalogue)

For a more complex example to show how this structure scales, see https://github.com/AeternaGroup/azurelandingzone

## Prerequisites

- **Docker** or **Podman** running 
- **Terragrunt** 1.0 or later.
- **OpenTofu** 1.6 or later, or Terraform.

## Deployment

```bash
git clone https://github.com/AeternaGroup/foundry-quickstart.git
cd quickstart
```

Open `./containers/terragrunt.hcl` in your IDE of choice

Change the values for the first and second colours, then save the file

From the root of this repo, run 
```bash
terragrunt run --all apply
```

## What this creates

Two terragrunt units, each pointing at a ready-made module

| Unit | Module | Creates |
|---|---|---|
| `image` | [`module_docker_image`](https://github.com/AeternaFoundry/module_docker_image) | The nginx image |
| `containers` | [`module_docker_container`](https://github.com/AeternaFoundry/module_docker_container) | One container per map entry |

Using Aeterna IaC Foundry we don't need to spend any time writing modules for resources, just the inputs that define the resources. All resource outputs are available to be used as dependencies for other units (e.g. we deploy an image and use its ID to launch our web containers)

## Start writing inputs

Add a third server. In [containers](./containers/terragrunt.hcl), add one entry to the map:

```hcl
    third = {
      name  = "aeterna-quickstart-third"
      image = dependency.image.outputs.images_image_id["nginx"]
      ports = [{ internal = 80, external = 8083 }]
    }
```

Then apply that unit:

```bash
cd containers
terragrunt apply
```

One container is added and nothing else changes. Open [localhost:8083](http://localhost:8083).

Every other module works the same way, whether it is an Azure storage account, an AWS bucket or a
Datadog monitor. Learn one and you have learned them all!

## With an AI assistant

Because every module has the same shape, an assistant only has to write inputs. Try:

> In containers/terragrunt.hcl, add a fourth web server on port 8084 whose page has a yellow
> background.

## Clean up

```bash
terragrunt run --all destroy
```

## Notes

- **Podman:** if using Podman, point the Docker provider at Podman's socket first:
  `export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock`
- **The first plan after an apply** can list "Changes to Outputs" for the containers. The provider
  fills in some values only when it first reads a container back. Apply once more and the plan is
  clean.
- **Older Terragrunt:** use `terragrunt run-all apply` in place of `terragrunt run --all apply`.

## Next

- [The catalogue](https://aeternaltd.net/foundry/catalogue): every module and lookup, for every provider we
  support.
- [Docs](https://aeternaltd.net/foundry/docs): how modules, lookups and versions work.
- [The Private edition](https://aeternaltd.net/foundry/pricing): new provider versions the day we
  publish them, delivered into your own GitHub organisation.
- [Packages](https://aeternaltd.net/foundry/docs/packages): When individual resources would need too many units, packages condense related resources into a single module using the same input and output shape
