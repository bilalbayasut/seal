---
description: >-
  Refactor existing project for production ready. Using workspace, environment
  variables, terraform outputs, modules.
---

# Refactor to production ready

## Utilizing Workspace

Terraform workspaces enable us to manage multiple deployments of the same configuration. When we create cloud resources using the Terraform configuration language, the resources are created in the default workspace. It is a very handy tool that lets us test configurations by giving us flexibility in resource allocation, regional deployments, multi-account deployments, and so on.

### How to use Terraform workspace

```bash
terraform workspace --help
Usage: terraform [global options] workspace

  new, list, show, select, and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace
```

## Utilizing Environment Variable

## Utilizing Modules

A _Terraform module_ is a collection of standard configuration files in a dedicated directory. Terraform modules encapsulate groups of resources dedicated to one task, reducing the amount of code you have to develop for similar infrastructure components.

To run the terraform with environment variable use:\
`terraform plan -var-file=staging.env`

## Utilizing Remote State
