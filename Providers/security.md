**AWS Security**

## 🎯 Goal

In this phase, we'll secure our AWS infrastructure using IAM and Security Groups.

Security is one of the most important aspects of any cloud environment. Instead of giving users or applications permanent AWS access keys, AWS recommends using IAM Roles with temporary credentials.

---

# 🏗️ Architecture

```text
                         Internet
                             │
                             ▼
                   Application Load Balancer
                             │
                   Security Group (ALB)
                             │
                Allows HTTP/HTTPS (80/443)
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
         ▼                                       ▼
      EC2 Instance A                        EC2 Instance B
         │                                       │
         │  Security Group (App)
         │  Allows Port 8080 only from ALB
         │
         ▼
    IAM Instance Profile
         │
         ▼
      IAM Role
         │
         ▼
     IAM Policy
         │
         ▼
     Amazon S3 Bucket
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Security Groups | Control inbound and outbound network traffic |
| IAM Role | Provides temporary AWS credentials to AWS resources |
| IAM Policy | Defines permissions for AWS resources |
| IAM Instance Profile | Attaches an IAM Role to an EC2 instance |

---

# Real-World Scenario

A production web application runs on Amazon EC2.

The application writes log files every day.

Instead of storing AWS Access Keys inside the application (which is insecure), the EC2 instance receives an IAM Role.

The IAM Role allows:

- Upload logs to Amazon S3
- Read configuration from AWS Systems Manager Parameter Store
- Send metrics to CloudWatch

No AWS Access Keys are stored anywhere.

This follows the AWS Security Best Practice of using temporary credentials.

---

# 1️⃣ Security Groups

## What is a Security Group?

A Security Group is a virtual firewall that controls inbound and outbound traffic for AWS resources.

Security Groups are **stateful**, meaning if inbound traffic is allowed, the response traffic is automatically allowed.

---

## Real-Time Example

Application Load Balancer

Allowed

- HTTP (80)
- HTTPS (443)

Blocked

- SSH
- Database Ports

EC2 Application Server

Allowed

- Port 8080 from ALB only
- SSH from Bastion Host only

Amazon RDS

Allowed

- Port 3306 only from EC2 Security Group

---

## Traffic Flow

```text
Internet
    │
    ▼
Security Group (ALB)
Allow:
80
443
    │
    ▼
Application Load Balancer
    │
    ▼
Security Group (EC2)
Allow:
8080 from ALB SG only
22 from Bastion only
    │
    ▼
EC2
    │
    ▼
Security Group (RDS)
Allow:
3306 from EC2 SG only
```

---

## Terraform

```hcl
resource "aws_security_group" "alb" {

  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}
```

---

# Best Practices

- Never allow SSH from 0.0.0.0/0 in production.
- Allow only required ports.
- Reference Security Groups instead of CIDR blocks where possible.
- Separate Security Groups for ALB, EC2, and RDS.

---

# 2️⃣ IAM Role

## What is an IAM Role?

An IAM Role is a temporary identity that grants AWS permissions without requiring permanent access keys.

AWS automatically provides temporary credentials to the resource.

---

## Real-Time Example

EC2 uploads:

- Application Logs
- Images
- Backups

to Amazon S3.

No AWS Access Key is stored inside the application.

---

## Architecture

```text
EC2 Instance
      │
      ▼
IAM Instance Profile
      │
      ▼
IAM Role
      │
      ▼
Amazon S3
```

---

## Terraform

```hcl
resource "aws_iam_role" "ec2_role" {

  name = "ProductionEC2Role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}
```

---

# Best Practices

- One role per application.
- Never share IAM Roles between unrelated workloads.
- Follow the Principle of Least Privilege.

---

# 3️⃣ IAM Policy

## What is an IAM Policy?

An IAM Policy defines what actions are allowed or denied.

Policies are written in JSON.

---

## Real-Time Example

Allow EC2 to:

- Upload logs to S3
- Read from Parameter Store
- Write CloudWatch Logs

Deny everything else.

---

## Terraform

```hcl
resource "aws_iam_policy" "s3_logs" {

  name = "S3LogUpload"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "s3:PutObject"

        ]

        Resource = "arn:aws:s3:::company-logs/*"

      }

    ]

  })

}
```

---

# Best Practices

- Use least privilege.
- Avoid wildcard "*" permissions.
- Grant only required actions.

---

# 4️⃣ IAM Instance Profile

## What is an IAM Instance Profile?

An IAM Instance Profile attaches an IAM Role to an EC2 instance.

EC2 cannot directly use an IAM Role.

It must use an Instance Profile.

---

## Real-Time Example

Developer launches EC2.

Instead of configuring:

```
AWS_ACCESS_KEY
AWS_SECRET_KEY
```

AWS automatically provides temporary credentials.

The application simply calls the AWS SDK.

---

## Architecture

```text
EC2
 │
 ▼
Instance Profile
 │
 ▼
IAM Role
 │
 ▼
Temporary AWS Credentials
 │
 ▼
Amazon S3
```

---

## Terraform

```hcl
resource "aws_iam_instance_profile" "ec2_profile" {

  name = "EC2Profile"

  role = aws_iam_role.ec2_role.name

}
```

---

# Complete Authentication Flow

```text
Application Running on EC2
            │
            ▼
AWS SDK
            │
            ▼
IAM Instance Profile
            │
            ▼
IAM Role
            │
            ▼
Temporary Credentials
            │
            ▼
Amazon S3
```

---

# 🎓 What You'll Learn

By completing this phase, you'll understand:

- Security Groups
- Stateful Firewalls
- IAM Roles
- IAM Policies
- IAM Instance Profiles
- Temporary AWS Credentials
- Principle of Least Privilege
- Secure EC2 to AWS Service Authentication

---

# ✅ Interview Questions

### Why should we use IAM Roles instead of Access Keys?

IAM Roles provide temporary credentials that AWS rotates automatically, eliminating the need to store long-lived access keys in applications.

---

### Can an EC2 instance directly use an IAM Role?

No.

An IAM Role must be attached to the EC2 instance through an IAM Instance Profile.

---

### What is the difference between an IAM Role and an IAM Policy?

| IAM Role | IAM Policy |
|----------|------------|
| Identity that AWS resources assume | Defines the permissions granted to that identity |

---

### What is the Principle of Least Privilege?

Grant only the permissions required for a user or application to perform its tasks—nothing more.

---

# 🏆 Production Best Practices

- Use IAM Roles instead of AWS Access Keys.
- Use Instance Profiles for EC2.
- Grant minimum required permissions.
- Separate Security Groups by tier (ALB, App, Database).
- Use Security Group references instead of opening ports to the internet.
- Audit IAM permissions regularly using IAM Access Analyzer.
