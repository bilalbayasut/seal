---
cover: >-
  https://images.unsplash.com/photo-1587654780291-39c9404d746b?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHw5fHxsZWdvJTIwYmxvY2tzfGVufDB8fHx8MTcyOTQ4NjE5MXww&ixlib=rb-4.0.3&q=85
coverY: 0
---

# Terraform: HCL (HashiCorp Configuration Language) Blocks

## Terraform Block Types

As a part of learning HCL we will cover these block types:

1. `terraform` block
2. `provider` block
3. `resource` block
4. `variable` block
5. `locals` block
6. `data` block
7. `module` block
8. `output` block
9. `null_resource` block
10. `provisioner` block

We will go over basic structure and purpose of each block. Once we are familiar with these blocks we can start building infrastructure that starts resembling something useful.

## terraform block

Terraform block is used for setting the version of the terraform we want. It may also contain `required_providers` block inside which specifies the versions of the providers we need as well as where Terraform should download these providers from. Terraform block is often put into a separate file called `terraform.tf` as a way to separate settings into their own file.

Here is an example of a terraform block:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.1"
}

```

## provider block

Provider blocks specifies special type of module that allows Terraform to interact with various cloud-hosting platforms or data centers. Providers must be configured with proper credentials before we can use them. In previous article we exported access key into our environment and that allowed us to deploy resources. Versions and download locations of providers are often specified inside the `terraform` block, but you can also specify it inside this block as well.

<pre class="language-hcl"><code class="lang-hcl"><strong>provider "aws" {
</strong>  version = "~> 3.0"
  region = "us-east-1"
}

</code></pre>

## resource block

Resource blocks are used to manage resources such as compute instances, virtual networks, databases, buckets, or DNS resources. This block type is the backbone of any terraform configuration because it represents actual resources with majority of other block types playing supporting role.

```hcl
resource "aws_instance" "example_resource" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  credit_specification {
    cpu_credits = "unlimited"
  }
}

```



## variable block

This block is often called an input variable block. Variable block provides parameters for terraform modules and allow users to customize the data provided to other terraform modules without modifying the source.

Variables are often in their own file called `variables.tf`. To use a variable it needs to be declared as a block. One block for each variable.

```hcl

variable "example_variable" {
  type = var_type
  description = var_description 
  default = value_1 
  sensitive = var_boolean_value 
}
```

Terraform has a strict order of precedence for variable setting. Here it is, from highest to lowest:

1. Command line (`-var` and `var-file`)
2. `*.auto.tfvars` or `*auto.tfvars.json`
3. `terraform.tfvars.json`
4. `terraform.tfvars` file
5. Env variables
6. Variable defaults

## locals block

Often called local variables block, this block is used to keep frequently referenced values or expressions to keep the code clean and tidy.

Locals block can hold many variables inside. Expressions in local values aren not limited to literal constants. They can also reference other values in the module to transform or combine them. These variables can be accessed using `local.var_name` notation, note that it is called `local.` when used to access values inside.

```hcl
locals {

  service_name = "forum"

  owner        = "Community Team"

  instance_ids = concat(aws_instance.blue..id, aws_instance.green..id)

}
```

## data block

Data block's primary purpose is to load or query data from APIs other than Terraform's. It can be used to provide flexibility to your configuration or to connect different workspaces. One way we would use data block in future articles is to query AWS API to get a list of active Availability Zones to deploy resources in.

Data is then accessed using dot notation using `var` identifier. For example: `var.variable_1`

<pre class="language-hcl"><code class="lang-hcl"><strong>data "data_type" "data_name" {
</strong>
  variable_1 = expression

}
</code></pre>

## module block

Modules are containers for multiple resources that are used together. A module consists of `.tf` and/or `.tf.json` files stored in a directory. It is the primary way to package and reuse resources in Terraform.

Every Terraform configuration has at least one model (root module) which contains resources defined in the `.tf` files. Test configuration we created in the third part of these series is a module.

Modules are a great way to compartmentalize reusable collections of resources in multiple configurations.

Here is an example of a module:\
[![Image description](https://media.dev.to/dynamic/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F32dp7v0od58x78hsyrhi.jpeg)](https://media.dev.to/dynamic/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F32dp7v0od58x78hsyrhi.jpeg)

## output block

This is a block which is almost always present in all configurations, along with `main.tf` and `variables.tf` block. It allows Terraform to output structured data about your configuration. This output can be used by users to see data like IPs or resources names in one convenient place. Another use case involves using this data in other Terraform workspace or sharing data between modules.

<pre class="language-hcl"><code class="lang-hcl"><strong>output "test_server_public_ip" {
</strong>
  description = "My test output for EC2 public IP"

  value = aws_instance.test_web_server.public_ip

  sensitive = true

}

output "public_url" {

  description = "Public URL for my web server"

  value = "https://${aws_instance.test_web_server.public_ip}:8000/index.html"

}
</code></pre>

## null\_resource block

The null\_resource in Terraform is similar to a standard resource. It adheres to the resource lifecycle model and serves as a placeholder for executing arbitrary actions within Terraform configurations without actually provisioning any physical resources. However, it does not perform any further actions beyond initialization

The null\_resource is useful for executing standard operations that do not require provisioning an actual resource. It can be declared as a simple resource block and used in [Terraform modules](https://spacelift.io/blog/what-are-terraform-modules-and-how-do-they-work) and other resources that depend on null resources.&#x20;

Below is the syntax for declaring a null\_resource:

```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo This command will execute whenever the configuration changes"
  }
}
```

* “resource” — indicates the declaration of a Terraform resource
* “null\_resource” — specifies the type of resource being declared
* “provisioner” — specifies the type of provisioner (example: local, remote, etc.)
* “triggers” — specifies what triggers this null\_resource to execute

### What is a trigger inside a null resource?

The default behavior of a null\_resource in Terraform is that it will execute only once during the first run of the `terraform apply` command.

Below is the sample code:

```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo This command will execute only once during apply"
  }
}
```

## provisioner block

#### What is the difference between Terraform null resource and provisioner?

A [Terraform ](https://spacelift.io/blog/terraform-null-resource)[null resource](https://spacelift.io/blog/terraform-null-resource) is a special resource that doesn’t create any infrastructure. It is the predecessor of terraform\_data, and it acts as a mechanism to trigger actions based on input changes. It can be used together with provisioners to achieve different operations that are configured in them.

### Terraform provisioners types

There are three types of provisioners in Terraform:&#x20;

* Local-exec provisioners
* Remote-exec provisioners
* File provisioners

Every time we provision a new set of cloud infrastructure, there is a purpose behind it.

For example, when we create an EC2 instance, we create it to accomplish certain tasks – executing heavy workloads, acting as a bastion host, or simply serving as the frontend for all incoming requests. To enable it to function, this instance needs more actions like installing a web server, applications, databases, setting network firewall, etc.

[Terraform](https://spacelift.io/blog/what-is-terraform) is a great IaC tool that helps us build infrastructure using code. Additionally, when the EC2 instance boots or is destroyed, it is also possible to perform some of the above tasks using provisioners in Terraform. In this post, we will explore the scenarios handled by provisioners, how they are implemented, and preferable ways to do it.

### What is a Terraform provisioner?

[Terraform provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax) have nothing in common with providers, they allow the execution of various commands or scripts on either local or remote machines, and they can also transfer files from a local environment to a remote one. There are three available provisioners: file (used for copying), local-exec (used for local operations), remote-exec (used for remote operations). The file and remote-exec provisioners need a connection block to be able to do the remote operations.

Provisioning mainly deals with configuration activities that happen after the resource is created. It may involve some file operations, executing CLI commands, or even executing the script. Once the resource is successfully initialized, it is ready to accept connections. These connections help Terraform log into the newly created instance and perform these operations.

It is worth noting that using Terraform provisioners for the activities described in this post should be considered as a last resort. The main reason is the availability of dedicated tools and platforms that align well with the use cases discussed in this post. Hashicorp suggests Terraform provisioners should only be considered when there is no other option. We discuss it further in the concluding section.

#### What is the difference between Terraform null resource and provisioner?

A [Terraform ](https://spacelift.io/blog/terraform-null-resource)[null resource](https://spacelift.io/blog/terraform-null-resource) is a special resource that doesn’t create any infrastructure. It is the predecessor of terraform\_data, and it acts as a mechanism to trigger actions based on input changes. It can be used together with provisioners to achieve different operations that are configured in them.

#### Terraform provider vs provisioner

[Terraform providers](https://registry.terraform.io/browse/providers) are plugins used to authenticate with cloud platforms, services or other tools, allowing users to create, modify, and delete resources declared in the Terraform configurations. Provisioners are used only for copying files or executing local or remote operations.

### Terraform provisioners types

There are three types of provisioners in Terraform:&#x20;

* Local-exec provisioners
* Remote-exec provisioners
* File provisioners

The diagram below represents various types of provisioners you can implement using Terraform at different stages of provisioning.

<figure><img src="https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F08%2Fterraform-provisioners-diagram.png&#x26;w=3840&#x26;q=75" alt=""><figcaption></figcaption></figure>

In the entire plan-apply-destroy cycle of Terraform, provisioners are employed at various stages to accomplish certain tasks. The local-exec provisioner is the simplest provisioner as it executes on the machine that hosts and executes Terraform commands. If the Terraform is installed on the developer’s local machine, the local-exec provisioner would run on the same machine.

It is simply because, unlike remote-exec and file provisioners, local-exec provisioners do not require connecting to the newly created resources to perform their tasks. Local-exec provisioner executes the commands or scripts on the host system and works on the data generated by the given Terraform configuration or data made available on the host machine.

As far as the target resources are concerned, we have to set up certain mechanisms to provide connection details to perform actions on the target machines. This is because the credentials used to log in to an EC2 instance are AWS key pairs (public and private keys) primarily.&#x20;

We will take a look at these provisioners in detail in the next sections.

Read more about [how to create AWS EC2 instance using Terraform](https://spacelift.io/blog/terraform-ec2-instance).

### How to use Terraform provisioners?

Provisioners can be used inside any resource. You just have to declare the provisioner block and use one of the available options: file, local-exec, remote-exec.

Let’s take a look at an example with local-exec with a null-resource:

```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello World!"
  }
}

# null_resource.example: Creating...
# null_resource.example: Provisioning with 'local-exec'...
# null_resource.example (local-exec): Executing: ["/bin/sh" "-c" "echo Hello World!"]
# null_resource.example (local-exec): Hello World!
# null_resource.example: Creation complete after 0s [id=someid]
```

This will only run a shell command that outputs Hello World.
