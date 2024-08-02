variable "environment" {
  type        = string
  nullable    = false
  description = "The environment name"
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

variable "ec2_instance_type" {
  type        = string
  nullable    = false
  description = "Type of EC2 instance"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy in"
}

variable "app_image" {
  type = string
  description = "Docker image to run in the ECS cluster"
}

variable "ecs_cluster_name" {
  type = string
  description = "The name of ECS cluster"
}