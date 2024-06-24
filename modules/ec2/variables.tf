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
  description = "A list of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet IDs"
  type        = list(string)
}