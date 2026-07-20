**Phase 3 - Compute**

## 🎯 Goal

In this phase, we'll deploy a highly available and scalable application using Amazon EC2, Launch Templates, Auto Scaling Groups, and User Data.

Instead of manually creating EC2 instances, AWS can automatically launch and terminate instances based on application demand.

This ensures the application remains highly available while optimizing infrastructure costs.

---

# 🏗️ Architecture

```text
                         Internet
                             │
                             ▼
                  Application Load Balancer
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
         EC2 Instance 1            EC2 Instance 2
                │                         │
                └────────────┬────────────┘
                             │
                    Auto Scaling Group
                             │
                     Launch Template
                             │
          ┌──────────────────┴──────────────────┐
          │                                     │
     Amazon Linux                         User Data
                                             │
                                             ▼
                            Install Nginx / Apache
                            Install Application
                            Start Services
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| EC2 | Runs the application |
| Launch Template | Standard configuration for EC2 instances |
| Auto Scaling Group | Automatically adds or removes EC2 instances |
| User Data | Bootstraps EC2 instances during launch |

---

# 🛒 Real-World Scenario

An e-commerce website experiences heavy traffic during Black Friday or a festive sale.

Normal traffic:

- 2 EC2 instances

Sale traffic:

- 10–20 EC2 instances

When traffic decreases, unused EC2 instances are automatically terminated.

This provides:

- High Availability
- Cost Optimization
- Automatic Scaling
- Zero Manual Intervention

---

# Request Flow

```text
Users
   │
   ▼
Application Load Balancer
   │
   ▼
Auto Scaling Group
   │
   ├───────────────┐
   │               │
   ▼               ▼
EC2 Instance    EC2 Instance
   │               │
   └───────┬───────┘
           │
      Launch Template
           │
           ▼
       User Data Script
           │
           ▼
 Application Starts Automatically
```

---

# 1️⃣ Amazon EC2

## What is EC2?

Amazon EC2 (Elastic Compute Cloud) provides virtual servers in AWS.

You can install:

- Java
- Node.js
- Python
- .NET
- Docker
- Nginx
- Apache

or any application you need.

---

## Real-Time Example

An online shopping application runs on EC2 instances behind an Application Load Balancer.

Customers never access EC2 directly.

Traffic always flows through the Load Balancer.

---

## Terraform

```hcl
resource "aws_instance" "app" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app_a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "Application-Server"
  }

}
```

---

## Best Practices

- Launch EC2 in private subnets.
- Attach IAM Roles instead of Access Keys.
- Use Security Groups.
- Use EBS encryption.
- Enable detailed monitoring.

---

# 2️⃣ Launch Template

## What is a Launch Template?

A Launch Template is a reusable blueprint for launching EC2 instances.

It contains:

- AMI
- Instance Type
- IAM Role
- Security Groups
- User Data
- EBS Configuration
- Tags

Whenever Auto Scaling creates a new instance, it uses this template.

---

## Real-Time Example

Instead of manually configuring every new EC2 instance, the Launch Template ensures every server is identical.

This guarantees consistency across your environment.

---

## Terraform

```hcl
resource "aws_launch_template" "app" {

  name_prefix   = "production-app"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  user_data = base64encode(file("userdata/install-nginx.sh"))

}
```

---

## Best Practices

- Maintain one Launch Template per application.
- Version Launch Templates for controlled updates.
- Keep AMIs updated with security patches.

---

# 3️⃣ Auto Scaling Group (ASG)

## What is an Auto Scaling Group?

An Auto Scaling Group automatically adjusts the number of EC2 instances based on demand.

It monitors metrics such as:

- CPU Utilization
- Network Traffic
- Request Count
- Scheduled Scaling

---

## Real-Time Example

Traffic Pattern:

Morning

```
2 EC2 Instances
```

Black Friday Sale

```
12 EC2 Instances
```

Midnight

```
2 EC2 Instances
```

No manual intervention is required.

---

## Terraform

```hcl
resource "aws_autoscaling_group" "app" {

  desired_capacity = 2
  min_size         = 2
  max_size         = 10

  launch_template {

    id      = aws_launch_template.app.id
    version = "$Latest"

  }

  vpc_zone_identifier = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]

}
```

---

## Best Practices

- Deploy across multiple Availability Zones.
- Configure health checks.
- Set sensible minimum and maximum capacities.
- Attach the ASG to an Application Load Balancer.

---

# 4️⃣ User Data

## What is User Data?

User Data is a script that runs automatically the first time an EC2 instance starts.

It is commonly used to:

- Install packages
- Configure the server
- Deploy applications
- Start services

This eliminates manual server configuration.

---

## Real-Time Example

Every new EC2 instance automatically:

- Updates the operating system
- Installs Nginx
- Downloads the application
- Starts the web server

The instance becomes ready to serve traffic within minutes.

---

## User Data Script

```bash
#!/bin/bash

yum update -y

yum install nginx -y

systemctl enable nginx

systemctl start nginx

echo "<h1>Production Web Server</h1>" > /usr/share/nginx/html/index.html
```

---

# Auto Scaling Lifecycle

```text
CloudWatch Alarm
        │
        ▼
CPU > 70%
        │
        ▼
Auto Scaling Group
        │
        ▼
Launch Template
        │
        ▼
Create New EC2
        │
        ▼
Run User Data
        │
        ▼
Install Application
        │
        ▼
Register with ALB
        │
        ▼
Serve User Requests
```

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon EC2
- Launch Templates
- Auto Scaling Groups
- User Data
- Multi-AZ Deployments
- High Availability
- Horizontal Scaling
- Infrastructure Automation

---

# ✅ Interview Questions

### Why do we use Launch Templates?

Launch Templates ensure every EC2 instance is created with the same configuration, reducing configuration drift and simplifying scaling.

---

### Why use Auto Scaling Groups?

Auto Scaling Groups improve:

- High Availability
- Fault Tolerance
- Cost Optimization

by automatically adjusting capacity based on demand.

---

### What is User Data?

User Data is a startup script that runs automatically when an EC2 instance launches, allowing software installation and application configuration without manual intervention.

---

### Can an Auto Scaling Group launch EC2 instances in multiple Availability Zones?

Yes.

This improves fault tolerance and ensures the application remains available even if one Availability Zone experiences an outage.

---

# 🏆 Production Best Practices

- Place EC2 instances in private subnets.
- Use Launch Templates instead of Launch Configurations.
- Enable Auto Scaling across at least two Availability Zones.
- Store application logs in CloudWatch.
- Attach IAM Roles instead of AWS Access Keys.
- Use User Data for automated server provisioning.
- Keep instances immutable by updating the Launch Template rather than making manual changes.
