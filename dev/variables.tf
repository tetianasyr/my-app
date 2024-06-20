variable "region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "vpc_config" {
  description = "A map of VPC configurations"
  type = map(object({
    vpc_cidr             = string
    public_subnet_count  = number
    private_subnet_count = number
  }))
}

variable "environment" {
  type        = string
  nullable    = false
  description = "The environment name"
}