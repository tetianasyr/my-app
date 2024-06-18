aws_region         = "us-east-1"

environment = "dev"

vpc_config ={
  dev_vpc1 = {
    vpc_cidr             = "172.16.0.0/16"
    public_subnet        = ["172.16.1.0/24", "172.16.2.0/24"]
    private_subnet       = ["172.16.3.0/24", "172.16.4.0/24"]
  },
  dev_vpc2 = {
    vpc_cidr             = "172.31.0.0/16"
    public_subnet        = ["172.31.1.0/24", "172.31.2.0/24"]
    private_subnet       = ["172.31.3.0/24", "172.31.4.0/24"]
  }
}