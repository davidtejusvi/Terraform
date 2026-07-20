# ⚖️ Phase 4 — Load Balancing

## 🎯 Goal

In this phase, we'll configure an **Application Load Balancer (ALB)** to distribute incoming HTTP/HTTPS requests across multiple EC2 instances.

Instead of users connecting directly to EC2 instances, all traffic flows through the ALB. The ALB continuously monitors application health and automatically routes traffic only to healthy instances.

This architecture improves:

- High Availability
- Fault Tolerance
- Scalability
- Zero Downtime Deployments

---

# 🏗️ Architecture

```text
                           Internet
                               │
                               ▼
                         Route 53 (DNS)
                               │
                               ▼
                       CloudFront (Optional)
                               │
                               ▼
                      Application Load Balancer
                    (Public Subnets - Multi AZ)
                               │
               ┌───────────────┴───────────────┐
               │                               │
               ▼                               ▼
        Target Group                     Target Group
               │                               │
        ┌──────┴──────┐                 ┌──────┴──────┐
        ▼             ▼                 ▼             ▼
      EC2-A         EC2-B             EC2-C         EC2-D
   (Healthy)     (Healthy)         (Healthy)      (Healthy)

              Health Checks Every 30 Seconds
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Application Load Balancer | Distributes incoming HTTP/HTTPS requests |
| Target Group | Groups backend EC2 instances |
| Health Check | Detects unhealthy instances and stops routing traffic |

---

# 🛒 Real-World Scenario

An online shopping website receives thousands of requests every minute.

Without a Load Balancer:

```
Users
   │
   ▼
Single EC2

❌ If EC2 fails

Website is DOWN.
```

With an Application Load Balancer:

```
Users
   │
   ▼
Application Load Balancer
   │
 ┌─┴───────────────┐
 ▼                 ▼
EC2-1            EC2-2

If EC2-1 fails,

ALB automatically sends traffic only to EC2-2.
```

Users continue shopping without noticing any interruption.

---

# Request Flow

```text
Client
   │
   ▼
DNS (Route53)
   │
   ▼
Application Load Balancer
   │
   ▼
Target Group
   │
 ┌─┴──────────────┐
 ▼                ▼
EC2-1          EC2-2
 │                │
 └──────┬─────────┘
        ▼
Application Response
```

---

# 1️⃣ Application Load Balancer (ALB)

## What is an Application Load Balancer?

An Application Load Balancer (ALB) distributes HTTP and HTTPS traffic across multiple application servers.

Unlike a Network Load Balancer, the ALB understands:

- URLs
- Hostnames
- HTTP Headers
- HTTP Methods

This allows advanced routing.

---

## Real-Time Example

Website:

```
www.shop.com
```

Routing Rules

```
/products  → Product Service

/orders    → Order Service

/payments  → Payment Service

/admin     → Admin Service
```

One ALB can route requests to different backend applications.

---

## Terraform

```hcl
resource "aws_lb" "app" {

  name               = "production-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

}
```

---

## Best Practices

- Deploy ALB in at least two Public Subnets.
- Enable HTTPS using ACM certificates.
- Enable Access Logs to Amazon S3.
- Configure Idle Timeout appropriately.
- Use Security Groups to allow only HTTP/HTTPS traffic.

---

# 2️⃣ Target Group

## What is a Target Group?

A Target Group contains the backend resources that receive traffic from the Load Balancer.

Targets can be:

- EC2 Instances
- ECS Tasks
- IP Addresses
- Lambda Functions

The ALB forwards traffic only to healthy targets.

---

## Real-Time Example

```
Application Load Balancer
            │
            ▼
      Target Group
            │
    ┌───────┴────────┐
    ▼                ▼
 EC2-A            EC2-B
```

If one server becomes unhealthy, the ALB automatically stops sending traffic to it.

---

## Terraform

```hcl
resource "aws_lb_target_group" "app" {

  name     = "production-tg"

  port     = 80

  protocol = "HTTP"

  vpc_id   = aws_vpc.main.id

}
```

---

## Best Practices

- One Target Group per application.
- Use meaningful names.
- Configure health checks carefully.
- Keep applications stateless whenever possible.

---

# 3️⃣ Health Checks

## What are Health Checks?

The ALB continuously checks whether each EC2 instance is healthy.

If an instance fails, it is removed from the Target Group automatically.

Once it becomes healthy again, it is added back.

No manual action is required.

---

## Real-Time Example

```
ALB

│

├── EC2-1 ✅ Healthy

├── EC2-2 ❌ Failed

└── EC2-3 ✅ Healthy
```

Traffic automatically goes to:

- EC2-1
- EC2-3

No traffic reaches EC2-2 until it passes the health check again.

---

## Terraform

```hcl
resource "aws_lb_target_group" "app" {

  name     = "production-tg"

  port     = 80

  protocol = "HTTP"

  vpc_id   = aws_vpc.main.id

  health_check {

    path                = "/"

    protocol            = "HTTP"

    healthy_threshold   = 3

    unhealthy_threshold = 2

    timeout             = 5

    interval            = 30

  }

}
```

---

# Load Balancing Workflow

```text
Users
   │
   ▼
Application Load Balancer
   │
   ▼
Target Group
   │
   ├───────────────┐
   ▼               ▼
EC2-A           EC2-B
Healthy         Unhealthy
   │                │
   ▼                X
Receive Traffic   Removed Automatically
```

---

# 🎓 What You'll Learn

By completing this phase, you'll understand:

- Application Load Balancer
- Layer 7 Load Balancing
- Target Groups
- Health Checks
- Request Routing
- High Availability
- Fault Tolerance
- Multi-AZ Load Balancing

---

# ✅ Interview Questions

### Why do we use an Application Load Balancer?

To distribute HTTP/HTTPS traffic across multiple application servers, improving availability, scalability, and fault tolerance.

---

### What happens if an EC2 instance becomes unhealthy?

The ALB detects the failure through health checks and stops routing traffic to that instance until it becomes healthy again.

---

### What is a Target Group?

A Target Group is a collection of backend resources (such as EC2 instances) that receive traffic from the Application Load Balancer.

---

### Can one ALB route traffic to multiple applications?

Yes.

Using listener rules, one ALB can route traffic based on:

- URL Path
- Host Header
- HTTP Header
- Query String
- HTTP Method

Example:

```
/api/*        → API Service

/admin/*      → Admin Service

/images/*     → Image Service
```

---

# 🏆 Production Best Practices

- Deploy the ALB across at least two Availability Zones.
- Place the ALB in public subnets and application servers in private subnets.
- Enable HTTPS using ACM certificates.
- Configure health checks with realistic thresholds.
- Enable ALB access logs and send them to Amazon S3.
- Attach the ALB to an Auto Scaling Group for automatic registration and deregistration of EC2 instances.
- Use path-based or host-based routing to support multiple applications behind a single ALB.
