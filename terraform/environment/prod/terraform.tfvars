environment = "prod"
ec2_instance_type = "t2.micro"
build_version = "v.1.0"
app_count = 2
task_cpu = 256
task_memory = 512
# min_app_count = 1
# app_count = 1
max_app_count = 2

vpc_cidr             = "172.21.0.0/16"
public_subnet_count  = 2
private_subnet_count = 2