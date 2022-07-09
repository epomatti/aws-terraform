terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}

### VPC ###

resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  # Enable DNS hostnames 
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"

  # Auto-assign public IPv4 address
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.10.0/24"

  # Auto-assign public IPv4 address
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1b"

  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.20.0/24"

  # Auto-assign public IPv4 address
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1c"

  tags = {
    Name = "subnet3"
  }
}


### Aurora Database ###

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_rds_cluster" "mysql" {
  cluster_identifier  = "aurora-mysql-cluster"
  engine              = "aurora-mysql"
  engine_version      = "8.0.mysql_aurora.3.02.0"
  database_name       = "mydb"
  master_username     = "dbadmin"
  master_password     = var.db_password
  skip_final_snapshot = true

  # Deletion production disabled
  deletion_protection = false

  # AZs
  availability_zones   = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  db_subnet_group_name = aws_db_subnet_group.default.name

  # from 1 to 35
  backup_retention_period = 35

  depends_on = [
    aws_vpc.default
  ]
}

# resource "aws_rds_cluster_instance" "cluster_instances" {
#   identifier         = "aurora-cluster-instance"
#   cluster_identifier = aws_rds_cluster.mysql.id
#   instance_class     = var.db_instance_class
#   engine             = aws_rds_cluster.mysql.engine
#   engine_version     = aws_rds_cluster.mysql.engine_version

#   # Aurora can go up to 15 read replicas - managed automatically
#   count = var.db_instance_count

#   # CloudWatch Granualarity - 1 to 60 seconds
#   monitoring_interval = 1

#   # Public access
#   publicly_accessible = true
# }
