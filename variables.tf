variable "aws_region" {
  type        = string
  nullable    = false
  description = "AWS region name"
}

variable "vpc_name" {
  type        = string
  nullable    = false
  description = "VPC name"
}

variable "vpc_cidr" {
  type = string
  nullable = false
  description = "The CIDR block for the VPC"
}

variable "public_subnet" {
  type        = string
  nullable    = false
  description = "The CIDR block for the public subnet"
}

variable "private_subnet" {
  type        = string
  nullable    = false
  description = "The CIDR block for the private subnet"
}