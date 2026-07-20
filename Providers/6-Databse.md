# 🗄️ Phase 6 — Database

## 🎯 Goal

In this phase, we'll deploy **Amazon RDS (Relational Database Service)** to securely store application data.

Instead of installing and managing MySQL or PostgreSQL on an EC2 instance, Amazon RDS provides a fully managed database service with automated backups, patching, monitoring, and Multi-AZ high availability.

Our application servers will communicate with the database over a private network, ensuring that the database is never exposed directly to the internet.

---

# 🏗️ Architecture

```text
                          Internet
                              │
                              ▼
                   Application Load Balancer
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
              EC2 Instance A      EC2 Instance B
            (Private Subnet)    (Private Subnet)
                    │                   │
                    └─────────┬─────────┘
                              │
                              ▼
                     Security Group
                   Allow Port 3306 Only
                              │
                              ▼
                     Amazon RDS MySQL
                    (Private DB Subnet)
                              │
                              ▼
                    Automated Backups
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon RDS | Managed relational database |
| DB Subnet Group | Deploys RDS inside private subnets |
| Security Group | Allows database access only from application servers |
| Multi-AZ | High availability and automatic failover |
| Automated Backup | Database recovery and point-in-time restore |

---

# 🛒 Real-World Scenario

An online shopping application stores all business data in Amazon RDS.

Examples include:

### User Management

- User Accounts
- Login Credentials
- User Profiles
- Addresses

### Product Management

- Product Catalog
- Categories
- Inventory
- Pricing

### Order Management

- Orders
- Order Items
- Shipping Details

### Payment System

- Payment Transactions
- Invoice Information
- Payment Status

The application running on EC2 communicates with RDS over the private network.

Users never access the database directly.

---

# Database Request Flow

```text
Customer Places Order
          │
          ▼
Application (EC2)
          │
          ▼
Amazon RDS
          │
          ├── Store User
          ├── Store Product
          ├── Store Order
          └── Store Payment
```

---

# 1️⃣ Amazon RDS

## What is Amazon RDS?

Amazon RDS (Relational Database Service) is a fully managed relational database service.

AWS handles:

- Installation
- Database Patching
- Automated Backups
- Monitoring
- High Availability
- Storage Scaling

Supported database engines include:

- MySQL
- PostgreSQL
- MariaDB
- Oracle
- Microsoft SQL Server

---

## Real-Time Example

An e-commerce application stores:

```
Customers

Products

Orders

Payments

Invoices
```

All information is stored securely in Amazon RDS.

The application connects using:

```
JDBC

Node.js

Python

Java

.NET
```

---

## Terraform

```hcl
resource "aws_db_instance" "mysql" {

  identifier             = "production-db"

  engine                 = "mysql"

  engine_version         = "8.0"

  instance_class         = "db.t3.micro"

  allocated_storage      = 20

  storage_type           = "gp3"

  username               = var.db_username

  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name

  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible    = false

  multi_az               = true

  skip_final_snapshot    = false

}
```

---

# Best Practices

- Deploy RDS in Private Subnets.
- Enable Multi-AZ for production.
- Enable Automated Backups.
- Enable Storage Encryption.
- Use IAM authentication where supported.
- Store passwords securely using AWS Secrets Manager.

---

# 2️⃣ DB Subnet Group

## What is a DB Subnet Group?

A DB Subnet Group tells AWS which private subnets Amazon RDS can use.

A production database should always be deployed across multiple Availability Zones.

---

## Architecture

```text
Private DB Subnet A
        │
        ▼
Amazon RDS
        ▲
        │
Private DB Subnet B
```

---

## Terraform

```hcl
resource "aws_db_subnet_group" "main" {

  name = "production-db-subnet"

  subnet_ids = [

    aws_subnet.private_db_a.id,

    aws_subnet.private_db_b.id

  ]

}
```

---

# 3️⃣ Security Group

## Purpose

Protect the database.

Allow only application servers to connect.

Never allow database access directly from the internet.

---

## Traffic Flow

```text
Internet

   X

Blocked

----------------------------

EC2 Application

      │

      ▼

Security Group

Allow:

3306 from EC2 Security Group

      │

      ▼

Amazon RDS
```

---

## Terraform

```hcl
resource "aws_security_group" "rds" {

  name   = "rds-sg"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [

      aws_security_group.app.id

    ]

  }

}
```

---

# Multi-AZ High Availability

```text
Availability Zone A

Amazon RDS (Primary)

        │

Automatic Replication

        ▼

Availability Zone B

Amazon RDS (Standby)
```

If the primary database fails:

AWS automatically promotes the standby database.

Applications reconnect automatically with minimal downtime.

---

# Backup Strategy

```text
Amazon RDS

     │

     ├────────► Automated Daily Backup

     │

     ├────────► Point-in-Time Recovery

     │

     └────────► Manual Snapshot
```

Backups help recover from:

- Accidental deletion
- Corrupted data
- Application bugs
- Disaster recovery scenarios

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon RDS
- Managed Databases
- Private Database Architecture
- Multi-AZ Deployment
- DB Subnet Groups
- Database Security
- Automated Backups
- Disaster Recovery
- High Availability

---

# ✅ Interview Questions

### Why do we use Amazon RDS instead of installing MySQL on EC2?

Amazon RDS is a managed service. AWS automates backups, software patching, monitoring, storage management, and high availability, reducing operational overhead.

---

### Why should Amazon RDS be placed in private subnets?

Databases contain sensitive information and should not be directly accessible from the internet. Keeping RDS in private subnets limits access to trusted application servers.

---

### What is Multi-AZ?

Multi-AZ creates a synchronous standby database in another Availability Zone. If the primary database becomes unavailable, AWS automatically fails over to the standby instance.

---

### What is the purpose of a DB Subnet Group?

A DB Subnet Group specifies the private subnets where Amazon RDS can be deployed, enabling high availability across multiple Availability Zones.

---

### How should database credentials be stored?

Avoid hardcoding usernames and passwords in Terraform or application code. Use **AWS Secrets Manager** or **AWS Systems Manager Parameter Store** to store and manage credentials securely.

---

# 🏆 Production Best Practices

- Deploy Amazon RDS only in private subnets.
- Enable Multi-AZ for production workloads.
- Enable automated backups and point-in-time recovery.
- Encrypt data at rest using AWS KMS.
- Restrict access using Security Groups instead of IP addresses where possible.
- Use parameter groups to customize database settings.
- Monitor performance with Amazon CloudWatch and Enhanced Monitoring.
- Store database credentials securely in AWS Secrets Manager.
- Take manual snapshots before major upgrades or application deployments.
