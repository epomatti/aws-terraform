variable "region" {
  default = "sa-east-1"
  type    = string
}

variable "db_instance_class" {
  default = "db.t3.medium"
  type    = string
}

# Aurora allows you to create up to 15 read-replicas
variable "db_instance_count" {
  default = 2
  type    = number
}

variable "db_password" {
  default = "cv9a8sndfk1F3#f"
  type    = string
}

variable "db_monitoring_interval" {
  default = 1
  type    = number
}
