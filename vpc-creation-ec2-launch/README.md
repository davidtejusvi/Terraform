# Terraform AWS VPC with EC2 Web Server

## Overview

This Terraform project provisions a custom AWS network infrastructure and deploys an EC2 instance running an Apache web server using **AWS User Data**.

The infrastructure includes:

- Custom VPC
- Internet Gateway
- Two Public Subnets
- Two Private Subnets
- Two Database Subnets
- Public Route Table
- Route Table Associations
- Security Group
- EC2 Instance
- Apache Web Server installed using User Data

---
# AWS Resources Created

The Terraform configuration creates the following resources:

- Amazon VPC
- Internet Gateway
- 2 Public Subnets
- 2 Private Subnets
- 2 Database Subnets
- Public Route Table
- Route Table Associations
- Security Group
- Amazon EC2 Instance
- Apache HTTP Server

---

# Prerequisites

Before deploying this project, make sure you have:

- Terraform 1.5 or later installed
- AWS CLI installed
- AWS account with required permissions

Check installations:

```bash
terraform version

aws --version

Configure AWS credentials:
aws configure

Project Structure
terraform-vpc-ec2-webserver/

│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
└── README.md

Terraform Variables Example
Example terraform.tfvars:
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

  "tf-db-subnet-1a" = "10.0.21.0/24"

  "tf-db-subnet-1b" = "10.0.22.0/24"

}


availability_zones = {

  "tf-public-subnet-1a"  = "ap-south-1a"

  "tf-public-subnet-1b"  = "ap-south-1b"

  "tf-private-subnet-1a" = "ap-south-1a"

  "tf-private-subnet-1b" = "ap-south-1b"

  "tf-db-subnet-1a"      = "ap-south-1a"

  "tf-db-subnet-1b"      = "ap-south-1b"

}


ami_id = "ami-xxxxxxxxxxxxxxxxx"


instance_type = "t3.micro"

Deploy Infrastructure
1. Initialize Terraform
terraform init

2. Validate Configuration
terraform validate

3. Format Terraform Files
terraform fmt

4. Review Terraform Plan
terraform plan

5. Create AWS Resources
terraform apply

Confirm with:
yes

Verify Web Server
Get EC2 instance details:
terraform output

Copy the EC2 public IP address.
Open your browser:

http://<EC2_PUBLIC_IP>

Expected output:
Hello from Terraform EC2

This webpage was deployed using AWS User Data

User Data Configuration
The EC2 instance automatically:
Updates system packages
Installs Apache HTTP Server
Starts Apache service
Enables Apache on system boot
Creates an HTML webpage
Example:
#!/bin/bash

dnf update -y

dnf install httpd -y

systemctl start httpd

systemctl enable httpd

Destroy Infrastructure
To remove all AWS resources created by Terraform:
terraform destroy

Confirm:
yes

Security Notes
Public subnets automatically assign public IP addresses.
Private and database subnets do not assign public IP addresses.
Security Group allows:
SSH Port 22
HTTP Port 80
For production environments:
Restrict SSH access to trusted IP addresses.
Avoid using 0.0.0.0/0 for SSH access.
Add NAT Gateway for private subnet outbound internet access.
Use AWS Systems Manager Session Manager instead of SSH where possible.
