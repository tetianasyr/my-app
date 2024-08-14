environment = "dev"
ec2_instance_type = "t2.micro"
build_version = "latest"
task_cpu = 256
task_memory = 512
min_app_count = 1
app_count = 1
max_app_count = 2

vpc_cidr             = "172.21.0.0/16"
public_subnet_count  = 2
private_subnet_count = 2

# cpu, memory, per env, rename resource (add env, region), add app_count (number of containers) into .tfvars
# create one more env, check deployment
# change in app_image "latest" to build version (add tag)