# Providers

Terraform providers are plugins that allow Terraform to interact with external services, platforms, and APIs to manage resources. These are listed in the documentation which can be found on the [Terraform Registry.](https://spacelift.io/blog/terraform-registry)

Providers are usually managed by either Hashicorp, the dedicated teams from the company making the provider (e.g. Mongo for the `mongodb` provider), or by community groups, users, and volunteers with an interest in the product or platform the provider utilizes.

### Terraform Provider Block Example

<figure><img src="../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

In the example shown above for the Microsoft Azure provider `azurerm` , the provider source and version are specified in the `required_providers` section. The `providers` block then contains the configuration options required by the provider. For example, `azurerm` includes `features` , `clientid` , `subscription_id` , `tenant_id` amongst others. Usually, provider configuration options include various ways to authenticate to the platform.
