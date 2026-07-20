AWS Resources with Real-Time Scenarios

1. VPC (Virtual Private Cloud)
Purpose

A private network inside AWS.

Real-Time Scenario

A banking application requires complete network isolation.

VPC
│
├── Public Subnet
│      ALB
│
└── Private Subnet
       EC2
       RDS
Terraform
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Production-VPC"
  }
}

Best Practice

One VPC per environment
Enable DNS Hostnames
Use CIDR planning
2. Internet Gateway
Purpose

Provides internet access to public resources.

Scenario

Users access your website through ALB.

Terraform

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

Best Practice

Attach only one IGW per VPC.

3. Route Table

Scenario

Route internet traffic.

Terraform

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

}

Best Practice

Separate public and private route tables.

4. NAT Gateway

Scenario

Private EC2 downloads updates without exposing itself.

Internet
     │
 IGW
     │
NAT Gateway
     │
Private EC2

Terraform

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

Best Practice

One NAT Gateway per AZ.

5. Public Subnet

Scenario

ALB resides here.

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

}
6. Private Subnet

Scenario

Application servers.

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

}
7. EC2

Scenario

Host Node.js application.

resource "aws_instance" "app" {

  ami = "ami-xxxxxxxx"

  instance_type = "t3.micro"

}

Best Practice

Never SSH using root.

8. Security Group

Scenario

Allow HTTP only.

resource "aws_security_group" "web" {

 ingress {

 from_port = 80

 to_port = 80

 protocol = "tcp"

 cidr_blocks = ["0.0.0.0/0"]

 }

}
9. IAM

Scenario

EC2 uploads logs to S3.

resource "aws_iam_role" "ec2" {

 name = "EC2Role"

}

Best Practice

Least privilege.

10. S3

Scenario

Store Terraform state.

resource "aws_s3_bucket" "bucket" {

 bucket = "company-terraform-state"

}

Best Practice

Enable Versioning.

11. EBS

Scenario

Extra storage for database.

resource "aws_ebs_volume" "data" {

 availability_zone = "eu-west-1a"

 size = 50

}
12. Elastic IP

Scenario

Static IP for NAT Gateway.

resource "aws_eip" "nat" {}
13. Application Load Balancer

Scenario

Distribute traffic.

resource "aws_lb" "alb" {

 load_balancer_type = "application"

}
14. Auto Scaling Group

Scenario

Scale from 2 → 10 EC2.

resource "aws_autoscaling_group" "asg" {

 desired_capacity = 2

}
15. Launch Template

Scenario

Blueprint for EC2.

resource "aws_launch_template" "lt" {

 image_id = "ami-xxxx"

 instance_type = "t3.micro"

}
16. CloudWatch

Scenario

Monitor CPU.

resource "aws_cloudwatch_metric_alarm" "cpu" {

 alarm_name = "HighCPU"

}
17. SNS

Scenario

Send email alerts.

resource "aws_sns_topic" "alerts" {

 name = "alerts"

}
18. SQS

Scenario

Queue orders.

resource "aws_sqs_queue" "orders" {

 name = "orders"

}
19. Lambda

Scenario

Resize uploaded images.

resource "aws_lambda_function" "resize" {

 function_name = "ResizeImage"

}
20. API Gateway

Scenario

Expose Lambda as REST API.

resource "aws_api_gateway_rest_api" "api" {

 name = "OrdersAPI"

}
21. RDS

Scenario

MySQL backend.

resource "aws_db_instance" "mysql" {

 engine = "mysql"

}
22. DynamoDB

Scenario

Store shopping carts.

resource "aws_dynamodb_table" "cart" {

 hash_key = "UserID"

}
23. EFS

Scenario

Shared storage across EC2.

resource "aws_efs_file_system" "efs" {

 creation_token = "efs"

}
24. ECR

Scenario

Store Docker images.

resource "aws_ecr_repository" "repo" {

 name = "node-app"

}
25. ECS

Scenario

Run Docker containers without managing Kubernetes.

resource "aws_ecs_cluster" "cluster" {

 name = "ecs"

}
26. EKS

Scenario

Deploy microservices using Kubernetes.

resource "aws_eks_cluster" "cluster" {

 name = "production"

}
27. Route 53

Scenario

Map domain to ALB.

resource "aws_route53_record" "www" {

 type = "A"

}
28. ACM

Scenario

HTTPS certificate.

resource "aws_acm_certificate" "cert" {

 domain_name = "example.com"

 validation_method = "DNS"

}
29. CloudFront

Scenario

Deliver website globally with low latency.

User

   │

CloudFront

   │

S3 Bucket

Terraform

resource "aws_cloudfront_distribution" "cdn" {

 enabled = true

}

Best Practice

Use ACM certificates for HTTPS.
Restrict S3 access with Origin Access Control (OAC).
Configure caching behaviors appropriately.
Real-Time Production Architecture

A common production setup combines many of these services:

Users
   │
Route 53
   │
CloudFront
   │
Application Load Balancer (Public Subnets)
   │
Auto Scaling Group (EC2 or ECS/EKS in Private Subnets)
   │
──────────────────────────────────────────
│               VPC                      │
│                                        │
│ Public Subnets                         │
│  • ALB                                │
│  • NAT Gateway                        │
│                                        │
│ Private App Subnets                   │
│  • EC2 / ECS / EKS                    │
│  • Lambda (when VPC-enabled)          │
│                                        │
│ Private DB Subnets                    │
│  • RDS                               │
│  • DynamoDB (AWS-managed, outside VPC)│
│                                        │
│ Shared Services                       │
│  • EFS                               │
│  • S3                                │
│  • ECR                               │
│  • IAM                               │
│  • CloudWatch                        │
│  • SNS                               │
│  • SQS                               │
└────────────────────────────────────────┘
