aws_region = "ap-south-1"


vpc_cidr = "10.0.0.0/16"


public_subnets = {

  "tf-public-subnet-1a" = "10.0.1.0/24"

  "tf-public-subnet-1b" = "10.0.2.0/24"

}


private_subnets = {

  "tf-private-subnet-1a" = "10.0.11.0/24"

  "tf-private-subnet-1b" = "10.0.12.0/24"

}


db_subnets = {

  "tf-db-subnet-1a" = "10.0.31.0/24"

  "tf-db-subnet-1b" = "10.0.32.0/24"

}


availability_zones = {

  "tf-public-subnet-1a" = "ap-south-1a"

  "tf-public-subnet-1b" = "ap-south-1b"

  "tf-private-subnet-1a" = "ap-south-1a"

  "tf-private-subnet-1b" = "ap-south-1b"

  "tf-db-subnet-1a" = "ap-south-1a"

  "tf-db-subnet-1b" = "ap-south-1b"

}



ami_id = "ami-0b1ed96948adabcd9"


instance_type = "t3.micro"
