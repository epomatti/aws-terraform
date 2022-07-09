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

resource "aws_rds_cluster" "mysql" {
  cluster_identifier = "aurora-mysql-cluster"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.02.0"
  # availability_zones      = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  database_name           = "mydb"
  master_username         = "dbadmin"
  master_password         = var.db_password
  backup_retention_period = 5
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "aurora-cluster-instance"
  cluster_identifier = aws_rds_cluster.mysql.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.mysql.engine
  engine_version     = aws_rds_cluster.mysql.engine_version
}
