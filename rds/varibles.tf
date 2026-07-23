variable "aws_region" {
  type        = string
  description = "aws region name"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance" {
  type = string
}

variable "db_version" {
  type = string
}

variable "db_storage" {
  type = number
}

variable "db_storage_type" {
  type = string
}

variable "db_identifier" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_mysql_name" {
  type = string
}

variable "db_backup_retention_period" {
  type = number
}

variable "db_deletion_protection" {
  type = bool
}
