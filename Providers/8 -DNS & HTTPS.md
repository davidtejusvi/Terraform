# 🌐 Phase 8 — DNS & HTTPS

## 🎯 Goal

In this phase, we'll configure **Amazon Route 53** for DNS management and **AWS Certificate Manager (ACM)** to enable secure HTTPS communication.

Users should never remember an AWS Load Balancer DNS name like:

```
production-alb-123456.ap-south-1.elb.amazonaws.com
```

Instead, they'll access the application using:

```
https://www.company.com
```

Route 53 resolves the domain name, while ACM provides a free SSL/TLS certificate for encrypted communication.

---

# 🏗️ Architecture

```text
                        User
                         │
             https://www.company.com
                         │
                         ▼
                 Amazon Route 53
                 (DNS Resolution)
                         │
                         ▼
               ACM SSL Certificate
              (HTTPS Termination)
                         │
                         ▼
          Application Load Balancer
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
      EC2 Instance A               EC2 Instance B
     (Private Subnet)            (Private Subnet)
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon Route 53 | DNS service that maps domain names to AWS resources |
| AWS Certificate Manager (ACM) | Provides free SSL/TLS certificates for HTTPS |

---

# 🛒 Real-World Scenario

A company owns the domain:

```
company.com
```

Customers access:

```
https://www.company.com
```

Request Flow

1. User enters **www.company.com** in the browser.
2. Route 53 resolves the domain.
3. Route 53 forwards the request to the Application Load Balancer.
4. ACM provides the SSL certificate.
5. HTTPS connection is established.
6. ALB forwards the request to healthy EC2 instances.

The entire communication is encrypted.

---

# Request Flow

```text
User Browser
      │
      ▼
www.company.com
      │
      ▼
Amazon Route 53
      │
      ▼
Application Load Balancer
(HTTPS using ACM)
      │
      ▼
EC2 Instances
      │
      ▼
Application Response
```

---

# 1️⃣ Amazon Route 53

## What is Amazon Route 53?

Amazon Route 53 is AWS's managed Domain Name System (DNS) service.

It translates human-readable domain names into IP addresses or AWS resource endpoints.

Example:

```
www.company.com
        │
        ▼
Application Load Balancer
```

Users never need to know the ALB DNS name.

---

## Real-Time Example

Instead of sharing:

```
production-alb-123456.ap-south-1.elb.amazonaws.com
```

Customers use:

```
https://www.company.com
```

Route 53 resolves the domain automatically.

---

## Terraform

```hcl
resource "aws_route53_record" "www" {

  zone_id = aws_route53_zone.main.zone_id

  name = "www"

  type = "A"

  alias {

    name = aws_lb.app.dns_name

    zone_id = aws_lb.app.zone_id

    evaluate_target_health = true

  }

}
```

---

## Best Practices

- Use Alias records for AWS resources.
- Enable health checks for failover.
- Use private hosted zones for internal applications.
- Manage DNS records using Terraform.

---

# 2️⃣ AWS Certificate Manager (ACM)

## What is ACM?

AWS Certificate Manager (ACM) provides free SSL/TLS certificates for AWS services.

Certificates are commonly attached to:

- Application Load Balancer
- CloudFront
- API Gateway

ACM automatically renews certificates before they expire.

---

## Real-Time Example

Without HTTPS

```
http://www.company.com
```

Problems

- Passwords sent in plain text
- Browser security warnings
- Data vulnerable to interception

With HTTPS

```
https://www.company.com
```

Benefits

- Secure communication
- Browser trust
- Encrypted data
- Improved SEO

---

## Terraform

```hcl
resource "aws_acm_certificate" "cert" {

  domain_name = "company.com"

  validation_method = "DNS"

}
```

---

# HTTPS Workflow

```text
User

 │

 ▼

https://www.company.com

 │

 ▼

Route53

 │

 ▼

ACM SSL Certificate

 │

 ▼

Application Load Balancer

 │

 ▼

EC2 Application
```

---

# DNS Resolution Workflow

```text
Browser

 │

 ▼

www.company.com

 │

 ▼

Route53 Hosted Zone

 │

 ▼

Alias Record

 │

 ▼

Application Load Balancer

 │

 ▼

EC2 Instances
```

---

# SSL Handshake Overview

```text
Client
   │
   ▼
HTTPS Request
   │
   ▼
Application Load Balancer
   │
   ▼
ACM Certificate
   │
   ▼
Secure TLS Connection Established
   │
   ▼
Encrypted Traffic
```

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon Route 53
- DNS Resolution
- Hosted Zones
- Alias Records
- AWS Certificate Manager
- SSL/TLS Certificates
- HTTPS Communication
- DNS Validation
- Secure Web Applications

---

# ✅ Interview Questions

### Why do we use Amazon Route 53?

Amazon Route 53 maps domain names such as **www.company.com** to AWS resources like an Application Load Balancer, making applications easy to access.

---

### Why do we use ACM?

AWS Certificate Manager provides free SSL/TLS certificates and automatically renews them, enabling secure HTTPS communication.

---

### Can ACM certificates be attached directly to EC2?

No.

ACM certificates are typically attached to AWS services such as:

- Application Load Balancer
- Network Load Balancer (TLS listeners)
- CloudFront
- API Gateway

---

### What is an Alias Record?

An Alias Record is a Route 53 record that points directly to AWS resources such as:

- Application Load Balancer
- CloudFront
- Amazon S3 Static Website
- API Gateway

Unlike a traditional CNAME, Alias records can be used at the root domain (for example, `company.com`).

---

### Why should websites use HTTPS?

HTTPS encrypts communication between the client and server, protecting sensitive information such as usernames, passwords, and payment details while increasing user trust and meeting modern security standards.

---

# 🏆 Production Best Practices

- Use Route 53 Alias Records instead of CNAMEs for AWS resources.
- Configure ACM certificates using DNS validation.
- Enable automatic certificate renewal.
- Terminate HTTPS at the Application Load Balancer.
- Redirect all HTTP traffic to HTTPS.
- Use Route 53 health checks and failover routing for critical applications.
- Store DNS infrastructure as Terraform code for consistency and repeatability.
