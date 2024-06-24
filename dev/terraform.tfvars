region = "us-east-1"

environment = "dev"
ec2_instance_type = "t2.micro"

vpc_config ={
  dev_vpc1 = {
    vpc_cidr             = "172.21.0.0/16"
    public_subnet_count  = 2
    private_subnet_count = 2
  },
  dev_vpc2 = {
    vpc_cidr             = "172.33.0.0/16"
    public_subnet_count        = 3
    private_subnet_count       = 2
  }
}