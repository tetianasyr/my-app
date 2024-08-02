region = "us-east-1"

ecs_cluster_name = "myapp-cluster-new"
environment = "dev"
ec2_instance_type = "t2.micro"
app_name = "my-pet-app-new"
app_image = "637423170103.dkr.ecr.us-east-1.amazonaws.com/my-pet-app-new:latest"

vpc_cidr             = "172.21.0.0/16"
public_subnet_count  = 2
private_subnet_count = 2
