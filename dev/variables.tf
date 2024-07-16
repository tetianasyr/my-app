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

variable "ec2_instance_type" {
  type        = string
  nullable    = false
  description = "Type of EC2 instance"
}

variable "ssh_public_key" {
  type        = string
  description = "The public key"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHWFgsy2l1lLDwfj2C3B/t0YVpoqgky+UCVwQ0iZaoVgHdttHGDyofHI+1satsL1Mwj/l1T8YibyKBGPt2SHnUGNuxeqtHeiUM5AqrxQzUZ7Tml6+3lI0IVFeuvE8rltHfCHbm7rqcMr7Z1VP4Svoz52elDJyV1TrfBwxVGJl7MsrIh3nsTqCM/Ske0fgJUpuVJyOcyqT0IeKmshGqFg8QyYhvvZFBNslSBMc4ku/YGXbnPxcYg9Lf/fJpFY6NBVt6+vRQzrQcDJWvhFPdPPtOVN6/Tj62kC8BNfQ+RQmXBACLOGRjlRFAJyrSr2PoxwjPjxuOpqncKtWEBiW5EZnsSnPeQUVg3D3UVosltOFet8Jhssp6gKcHMPcIAj+Gjnd15UNhyKNX84hV9ZKPGY5/LgQ3V/eAIMqhJQX2sacnG+/zSS8OcWLRFsLGXPR1rNKlrWYSZCgqr/0k7g05DLa89ct/vkMbL9PU3czh9mgiw0lcSDiIXc9g3wqVI6BuuuL3cTwvzOUx+0sy9at2RxhtCEa4tvy2m2HrH5NG+8+5X0G2sntTgt+pQQUZDWAJ95Wq9DzKNpqFBQGz2HBLatnxsPxM25qGJI/pDizvRCHsmRY2C1yVXTsPUXxW43DL5zsm7LnH43bgvW+HVXF3AeUYHXQdX/dgKmiwqxfgdOUasQ== tsyrov@CL6D7LP62G"
}
variable "app_name" {
  type = string
  description = "Application name"
}
variable "app_image" {
  type = string
  description = "Docker image to run in the ECS cluster"
}