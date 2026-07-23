
Terraform AWS VPC with EC2 Web Server
Overview
This Terraform project provisions a custom AWS network infrastructure and deploys an EC2 instance running an Apache web server using AWS User Data.
The infrastructure includes:

Custom VPC
Internet Gateway
Two Public Subnets
Two Private Subnets
Two Database Subnets
Public Route Table
Route Table Associations
Security Group
EC2 Instance
Apache Web Server installed using User Data
Architecture
                     Internet
                         |
                  Internet Gateway
                         |
                    Public Route Table
                         |
        ---------------------------------------
        |                                     |
  Public Subnet 1a                     Public Subnet 1b
        |
     EC2 Instance
     Apache Web Server

        ---------------------------------------
        |                                     |
 Private Subnet 1a                    Private Subnet 1b

        ---------------------------------------
        |                                     |
   DB Subnet 1a                        DB Subnet 1b

Resources Created
Amazon VPC
Internet Gateway
2 Public Subnets
2 Private Subnets
2 Database Subnets
Public Route Table
Route Table Associations
Security Group
Amazon EC2 Instance
Apache HTTP Server
Prerequisites
Before deploying, ensure you have:
Terraform 1.5 or later
AWS CLI configured
AWS account with appropriate permissions
Verify installations:
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

Variable Example
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

ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t3.micro"

Deploy the Infrastructure
Initialize Terraform:
terraform init

Validate the configuration:
terraform validate

Format the files:
terraform fmt

Review the execution plan:
terraform plan

Create the infrastructure:
terraform apply

Type:
yes

Verify the Web Server
Retrieve the EC2 public IP:
terraform output

Open the following URL in your browser:
http://<EC2_PUBLIC_IP>

You should see:
Hello from Terraform EC2

This webpage was deployed using AWS User Data

Destroy the Infrastructure
To remove all resources:
terraform destroy

Security Notes
Public subnets are configured to assign public IP addresses automatically.
Private and database subnets do not assign public IP addresses.
Security Group allows:
SSH (22)
HTTP (80)
For production, restrict SSH access to trusted IP addresses instead of 0.0.0.0/0.
Consider adding a NAT Gateway if private subnets require outbound internet access
