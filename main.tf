#Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.28.0"

    }
  }
}
provider "aws" {
  region     = var.awsRegion

}
#DataSource
data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
#Networking
resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_bloc
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = local.common_tags_f2i
  
}
resource "aws_internet_gateway" "app_igw" { #Internet Gateway Or public IP
    vpc_id = aws_vpc.app-vpc.id
    tags = local.common_tags_f2i
  
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = var.vpc_public_subnets_cidr_block

  tags = local.common_tags_f2i
  
}
#Routting
resource "aws_route_table" "route_table_app" {
    vpc_id  = aws_vpc.app-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_igw.id
    }
    tags = local.common_tags_f2i
  
}

resource "aws_route_table_association" "app_subnet" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.route_table_app.id
  
}
#SECURITY GROUPS FOR NGINX CONFIG 
resource "aws_security_group" "allow_http_https" {
  name        = "nginx_sg"
  description = "allow http inbound traffic"

  # http access from anywhere
  ingress {
    description = "hello_from"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound internet access 
  egress {
    description = "https anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# instance EC2
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = var.instanceType
  key_name      = "devops-mamadou"
  tags = local.common_tags_f2i

  root_block_device {
    delete_on_termination = true

  }

  vpc_security_group_ids = ["${aws_security_group.allow_http_https.id}"]

  user_data = <<-EOF
  #!/bin/bash
  sudo amazon-linux-extras install nginx1.12 -y
  sudo systemctl start nginx
  EOF

}