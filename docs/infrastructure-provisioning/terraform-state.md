---
cover: >-
  https://images.unsplash.com/photo-1529454516905-415953c10f97?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHwxfHxjb25kaXRpb258ZW58MHx8fHwxNzI5NDg2MjMwfDA&ixlib=rb-4.0.3&q=85
coverY: 129
---

# Terraform State

Terraform state is a record of the managed infrastructure. Each time you make an execution plan and attempt to create or modify resource, Terraform will compare your configuration to the existing state.

## Local backend

The location of the state file is specified in Terraform backend. By default the state is stored locally, in the working directory inside the `terraform.tfstate` file. Data is stored in the JSON format and is relatively human-readable. Please note that you should not modify this file. It is extremely rare for anyone to modify it and even in those instances you should know exactly what you are doing.

Backend settings are often specified in the `terraform.tf` file inside the `terraform` block. Not specifying a backend is equivalent to this code:\


```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # other settings...
}
```

## Remote State

In remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team. Terraform supports storing state in [HCP Terraform](https://www.hashicorp.com/products/terraform/), [HashiCorp Consul](https://www.consul.io/), Amazon S3, Azure Blob Storage, Google Cloud Storage, Alibaba Cloud OSS, and more.

Remote state is implemented by a [backend](https://developer.hashicorp.com/terraform/language/backend) or by HCP Terraform, both of which you can configure in your configuration's root module.

For example usage, see [the `terraform_remote_state` data source](https://developer.hashicorp.com/terraform/language/state/remote-state-data).
