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
  region = "sa-east-1"
}

### Dynamo ###

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Employee"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"
  range_key      = "Department"

  attribute {
    name = "Id"
    type = "N"
  }

  attribute {
    name = "Name"
    type = "S"
  }

  attribute {
    name = "Department"
    type = "S"
  }

  global_secondary_index {
    name               = "EmployeeNameIndex"
    hash_key           = "Name"
    range_key          = "Department"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["Id"]
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

}

# resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
#   max_capacity = 100
#   min_capacity = 5
#   # resource_id        = "table/Employee"
#   resource_id        = aws_dynamodb_table.basic-dynamodb-table.id
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
#   name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }

#     target_value = 70
#   }
# }
