terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }

    ansible = {
      version = "~> 1.1.0"
      source  = "ansible/ansible"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  # access_key = var.aws_access_key
  # secret_key = var.aws_serect_key
}

provider "docker" {}

locals {
  module_path        = abspath(path.module)
  codebase_root_path = abspath("${path.module}/..")
  # Trim local.codebase_root_path and one additional slash from local.module_path
  module_rel_path    = substr(local.module_path, length(local.codebase_root_path)+1, length(local.module_path))
}

##### VPC #####
# 2 Public Subnet
# 2 Private Subnet
# Interget Gateway
# Nat Gateway

# resource "aws_vpc" "lab-vpc" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   tags = {
#     "Name" = "lab-vpc"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.lab-vpc.id
#   tags = {
#     "Name" = "lab-igw"
#   }
# }

# resource "aws_subnet" "public_subnet_1" {
#   vpc_id = aws_vpc.lab-vpc.id
#   cidr_block = "10.0.0.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id = aws_vpc.lab-vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_subnet" "public_subnet_2" {
#   vpc_id = aws_vpc.lab-vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
# }

# resource "aws_subnet" "private_subnet_2" {
#   vpc_id = aws_vpc.lab-vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "us-east-1b"
# }

# resource "aws_eip" "nat" {
#   vpc = true
# }

# resource "aws_nat_gateway" "private_nat" {
#   depends_on = [
#     aws_internet_gateway.igw,
#     aws_eip.nat
#   ]

#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.private_subnet_1.id
# }


# resource "aws_route_table" "public-rt" {
#   vpc_id = aws_vpc.lab-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "public_association_1" {
#   subnet_id = aws_subnet.public_subnet_1.id
#   route_table_id = aws_route_table.public-rt.id
# }

# resource "aws_route_table_association" "public_association_2" {
#   subnet_id = aws_subnet.public_subnet_2.id
#   route_table_id = aws_route_table.public-rt.id
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.lab-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.private_nat.id
#   }
# }

# resource "aws_route_table_association" "private_association_1" {
#   subnet_id = aws_subnet.private_subnet_1.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_route_table_association" "private_association_2" {
#   subnet_id = aws_subnet.private_subnet_2.id
#   route_table_id = aws_route_table.private_rt.id
# }

# ##### Security Group #####

# resource "aws_security_group" "web_sg" {
#   name = "web_sg"
#   description = "Allow connection to"
#   vpc_id = aws_vpc.lab-vpc.id
#   ingress {
#     description = "Allow HTTP"
#     from_port = "80"
#     to_port = "80"
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow SSH"
#     from_port = "22"
#     to_port = "22"
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound"
#     from_port = "0"
#     to_port = "0"
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# ###### EC2 Instance #####

# resource "aws_instance" "app_server" {
#   ami           = "ami-0889a44b331db0194"
#   instance_type = "t2.micro"
#   key_name = "vockey"
#   subnet_id = aws_subnet.public_subnet_2.id
#   vpc_security_group_ids = [ aws_security_group.web_sg.id ]
#   user_data = <<EOF
# #!/bin/bash
# # Install Apache Web Server and PHP
# dnf install -y httpd wget php mariadb105-server
# # Download Lab files
# wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
# unzip lab-app.zip -d /var/www/html/
# # Turn on web server
# chkconfig httpd on
# service httpd start
# EOF

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

# resource "aws_eip" "web_eip" {
#   instance = aws_instance.app_server.id
#   vpc = true
# }

# ##### RDS #####

# resource "aws_security_group" "db_sg" {
#   name = "db_sg"
#   description = "Security group for DB"
#   vpc_id = aws_vpc.lab-vpc.id
#   ingress {
#     description = "Permit access from Web Security Group"
#     from_port = "3306"
#     to_port = "3306"
#     protocol = "tcp"
#     security_groups = [ aws_security_group.web_sg.id ]
#   }

#   tags = {
#     Name = "Database SG"
#   }
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name = "db_subnet_group"
#   description = "DB Subnet Group"
#   subnet_ids = [
#     aws_subnet.private_subnet_1.id,
#     aws_subnet.private_subnet_2.id
#   ]
# }

# resource "aws_db_instance" "lab_db" {
#   depends_on = [ 
#     aws_security_group.db_sg,
#     aws_db_subnet_group.db_subnet_group
#   ]
#   allocated_storage = 10
#   storage_type = "gp2"
#   engine = "mysql"
#   engine_version = "8.0.29"
#   instance_class = "db.t3.micro"
#   db_name = "dep304_asm2"
#   username = "main"
#   password = "Mypassword"

#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
#   vpc_security_group_ids = [ aws_security_group.db_sg.id ]
#   skip_final_snapshot = true
# }

##### Deploy MySQL container using Docker #####
resource "docker_image" "mysql_image" {
  name = "bitnami/mysql:8.0.32-debian-11-r26"
  keep_locally = true
}

resource "docker_container" "mysql_cont" {
  image = docker_image.mysql_image.image_id
  name  = "dep304x_asm2_mysql"
  memory = 2048
  cpu_shares = 2
  ports {
    internal = 3306
    external = 3306
  }
  env = [
    "MYSQL_ROOT_PASSWORD=Mypassword",
    "MYSQL_USER=main",
    "MYSQL_PASSWORD=Mypassword",
    "MYSQL_DATABASE=dep304_asm2"
  ]
  mounts {
    target = "/usr/local/share/data/"
    type = "bind"
    source = "${local.codebase_root_path}/data/"
  }
  mounts {
    target = "/usr/local/share/script/"
    type = "bind"
    source = "${local.codebase_root_path}/script/"
  }
  mounts {
    target = "/usr/local/share/ansible/"
    type = "bind"
    source = "${local.codebase_root_path}/ansible/"
  }
  mounts {
    target = "/etc/my.cnf"
    type = "bind"
    source = "${local.codebase_root_path}/my.cnf"
  }
}

resource "null_resource" "run_ansible_playbook" {
  depends_on = [ docker_container.mysql_cont ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${local.codebase_root_path}/ansible/inventory ${local.codebase_root_path}/ansible/docker-test.yaml"
  }
}
