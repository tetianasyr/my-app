region = "us-east-1"

ecs_cluster_name = "myapp-cluster"
environment = "dev"
ec2_instance_type = "t2.micro"
app_name = "my-petapp"
app_image = "public.ecr.aws/x8e1i6y6/my-pet-app:latest"


vpc_config ={
  dev_vpc1 = {
    vpc_cidr             = "172.21.0.0/16"
    public_subnet_count  = 2
    private_subnet_count = 2
  }
#   dev_vpc2 = {
#     vpc_cidr             = "172.33.0.0/16"
#     public_subnet_count        = 2
#     private_subnet_count       = 2
#   }
}