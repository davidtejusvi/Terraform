variable "aws_region" {

  description = "AWS Region"

  type = string

}


variable "vpc_cidr" {

  description = "VPC CIDR range"

  type = string

}


variable "public_subnets" {

  description = "Public subnet names and CIDR ranges"

  type = map(string)

}


variable "private_subnets" {

  description = "Private subnet names and CIDR ranges"

  type = map(string)

}


variable "db_subnets" {

  description = "Database subnet names and CIDR ranges"

  type = map(string)

}


variable "availability_zones" {

  description = "Mapping of subnet names to availability zones"

  type = map(string)

}


variable "ami_id" {

  description = "EC2 AMI ID"

  type = string

}


variable "instance_type" {

  description = "EC2 instance type"

  type = string

}


variable "name_prefix" {

  description = "Resource naming prefix"

  type = string

  default = "tf"

}
