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

## provider block

## resource block

## variable block

## locals block

## data block

## module block

## output block

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
