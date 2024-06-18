# variable "aws_region" {
#   type = string
#   nullable = false
#   description = "AWS Region"
# }

variable "vpc_cidr" {
  type = string
  nullable = false
  description = "The CIDR block for the VPC"
}

variable "public_subnet" {
  type        = list(string)
  nullable    = false
  description = "The list of CIDR blocks for the public subnet"
}

variable "private_subnet" {
  type        = list(string)
  nullable    = false
  description = "The list of CIDR blocks for the private subnet"
}

variable "environment" {
  type        = string
  nullable    = false
  description = "The environment name"
}


