---
description: >-
  Refactor existing project for production ready. Using workspace, environment
  variables, terraform outputs, modules.
cover: >-
  https://images.unsplash.com/photo-1503147658877-b6636154a299?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHwxMHx8cHJvZHVjdGlvbnxlbnwwfHx8fDE3Mjk0ODYzMzZ8MA&ixlib=rb-4.0.3&q=85
coverY: 0
---

# Terraform Hands On: Refactor to production ready

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

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }

  backend "s3" {
    bucket = "tfremotestate-ec2"
    key = "state"
    region = "eu-central-1"
    dynamodb_table = "tfremotestate-ec2"
  }
}
```

When we use S3 as the backend, Terraform automatically handles the storage and locking features.&#x20;

Refer to [this document](https://developer.hashicorp.com/terraform/language/settings/backends/s3) for information about additional features related to s3 and support available for other backends. (See also the [Terraform s3 backend best practices](https://spacelift.io/blog/terraform-s3-backend).)

In our case, Terraform internally handles the logic to store, manage, and lock state using AWS APIs. For other supported backends, Terraform handles the same internally with corresponding APIs.

If we now try to run the `terraform plan` command after enabling this backend, it will throw an error:

```hcl
terraform plan
╷
│ Error: Backend initialization required, please run "terraform init"
│ 
│ Reason: Initial configuration of the requested backend "s3"
│ 
│ The "backend" is the interface that Terraform uses to store state,
│ perform operations, etc. If this message is showing up, it means that the
│ Terraform configuration you're using is using a custom configuration for
│ the Terraform backend.
│ 
│ Changes to backend configurations require reinitialization. This allows
│ Terraform to set up the new configuration, copy existing state, etc. Please run
│ "terraform init" with either the "-reconfigure" or "-migrate-state" flags to
│ use the current configuration.
│ 
│ If the change reason above is incorrect, please verify your configuration
│ hasn't changed and try again. At this point, no changes to your existing
│ configuration or state have been made.
```

This is expected — since we have added a new backend setting in the provider block, Terraform has detected the same and asked us to reconfigure the backend with the “-migrate-state” flag. Doing this would let Terraform connect to the specified S3 bucket, and transfer the state files in that bucket.

```hcl
terraform init -migrate-state

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- terraform.io/builtin/terraform is built in to Terraform
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.10.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Creating S3 and dynamo db resources

create `backend.tf` in your directory&#x20;

```hcl
resource "aws_s3_bucket" "remote_state" {
  bucket        = "remote-state-123"
  force_destroy = true

  tags = {
    Name        = "remote-state"
    Environment = var.env
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "RemoteState"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }


  tags = {
    Name        = "remote-state"
    Environment = "production"
  }
}
```

after required resources are created, then add s3 backend in terraform provider, ie in versions.tf

<pre class="language-hcl"><code class="lang-hcl"><strong>terraform {
</strong>  required_version = ">=1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }

  backend "s3" {
    bucket         = "remote-state-123"
    key            = "state"
    region         = "us-east-1"
    dynamodb_table = "RemoteState"
  }
}

</code></pre>
