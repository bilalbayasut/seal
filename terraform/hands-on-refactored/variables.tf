variable "env" {
  description = "env"
  type        = string
}
variable "key_name" {
  description = "key_name"
  type        = string
}

#VPC
variable "vpc_name" {
  description = "vpc_name"
  type        = string
}
variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}
variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(any)
  default     = []
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
  default     = []
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(any)
  default     = []
}
variable "enable_nat_gateway" {
  description = "enable_nat_gateway"
  type        = bool
}
variable "enable_vpn_gateway" {
  description = "enable_vpn_gateway"
  type        = bool
}

variable"aws_region" {
  description = "aws_region"
  type        = string
}

# rds
variable "database_name" {
  description = "database name"
  type        = string
}
variable "database_user" {
  description = "database user"
  type        = string
}
variable "database_password" {
  description = "database_password"
  type        = string
}
variable "database_port" {
  description = "database_port"
  type        = string
}
