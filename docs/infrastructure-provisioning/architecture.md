---
cover: >-
  https://images.unsplash.com/photo-1712696779652-dfca8766c5f8?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHwyfHxibHVlcHJpbnR8ZW58MHx8fHwxNzI5NDg2Mjg1fDA&ixlib=rb-4.0.3&q=85
coverY: 0
---

# Architecture

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

## Terraform Core

Terraform’s core (also known as Terraform CLI) is built on a statically-compiled binary that’s developed using the Go programming language.

This binary is what generates the command line tool (CLI) known as “terraform,” which serves as the primary interface for Terraform users. It is open source and can be accessed on the [Terraform GitHub](https://spacelift.io/blog/terraform-github) repository.

## Providers

[Terraform providers](https://spacelift.io/blog/terraform-providers) are modules that enable Terraform to communicate with a diverse range of services and resources, including but not limited to cloud providers, databases, and DNS services.&#x20;

Each provider is responsible for defining the resources that Terraform can manage within a particular service and translating Terraform configurations into API calls that are specific to that service.

Providers are available for numerous services and resources, including those developed by major cloud providers like AWS, Azure, and Google Cloud, as well as community-supported providers for various services. By utilizing providers, Terraform users can maintain their infrastructure in a consistent and reproducible manner, regardless of the underlying service or provider.&#x20;

## State file

The [Terraform state file](https://spacelift.io/blog/terraform-state) is an essential aspect of Terraform’s functionality. It is a JSON file that stores information about the resources that Terraform manages, as well as their current state and dependencies.&#x20;

Terraform utilizes the state file to determine the changes that need to be made to the infrastructure when a new configuration is applied. It also ensures that resources are not unnecessarily recreated across multiple runs of Terraform.&#x20;

The state file can be kept locally on the machine running Terraform or remotely using a remote backend like Azure Storage Account or [Amazon S3](https://spacelift.io/blog/terraform-s3-backend), or HashiCorp Consul. It is crucial to safeguard the state file and maintain frequent backups since it contains sensitive information about the infrastructure being managed.

Note: New versions of Terraform are placed under the BUSL license, but everything created before version 1.5.x stays open-source. [OpenTofu](https://opentofu.org/) is an open-source version of Terraform that expands on Terraform’s existing concepts and offerings. It is a viable alternative to HashiCorp’s Terraform, being forked from Terraform version 1.5.6.

## Terraform Structure

Declaring resources is very easy in Terraform. [Terraform files](https://spacelift.io/blog/terraform-files) always end with the extension `.tf`.

The basic Terraform structure contains the following elements.

### Terraform Block

A Terraform block specifies the required providers that terraform needs in order to execute the script. This block also contains the source block that specifies from where terraform should download the provider and also the required version.

Below is an example:

```hcl
terraform { 
  required_providers { 
    azurerm = { 
      source  = "hashicorp/azurerm" 
      version = "=3.0.0" 
    } 
  } 
}
```

### Provider Block

A provider block specifies the cloud provider and the API credentials required to connect to the provider’s services. It includes the provider name, version, access key, and secret key.

For example, if you are using Azure as your service provider, it would look as follows:

```hcl
provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
  tenant_id = "11111111-1111-1111-1111-111111111111"
}
```

### Resource Block

A resource block represents a particular resource in the cloud provider’s services. It includes the resource type, name, and configuration details. This is the main block that specifies the type of resource we are trying to deploy.

Below is an example for creating a resource group in Azure.

```hcl
resource "azurerm_resource_group" "example" { 
  name = "example" 
  location = "West Europe" 
}
```

### Data Block

A data block is used to fetch data from the provider’s services, which can be used in resource blocks. It includes the data type and configuration details.

This is used in scenarios where the resource is already deployed, and you would like to fetch the details of that resource.

The code snippet below helps you to fetch details of an existing resource group that is already deployed.

```hcl
data "azurerm_resource_group" "example" { 
  name = "existing" 
}
```

### Variable Block

A variable block is used to define input variables that are used in the Terraform configuration. It includes the variable name, type, and default value.

Following is an example of a variable block in Terraform.

```hcl
variable "resource_group_name" {
  default = "myTFResourceGroup"
}
```

### Output Block

An output block is used to define [output values](https://spacelift.io/blog/terraform-output) that are generated by the Terraform configuration. It includes the output name and value.

```hcl
output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
```

## Terraform Workflow

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>
