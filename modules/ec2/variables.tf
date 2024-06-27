variable "environment" {
  type        = string
  nullable    = false
  description = "The environment name"
}

variable "ec2_instance_type" {
  type        = string
  nullable    = false
  description = "Type of EC2 instance"
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnet IDs"
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the VPC"
}

variable "ssh_public_key" {
  type        = string
  description = "The public key"
}

variable "iam_instance_profile" {
  type = string
  description = "The IAM instance profile"
}