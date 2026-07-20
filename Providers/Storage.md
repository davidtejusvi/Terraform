# 💾 Phase 5 — Storage

## 🎯 Goal

In this phase, we'll configure AWS storage services to provide durable, scalable, and highly available storage for our application.

Different AWS storage services solve different problems:

- **Amazon S3** stores objects such as images, videos, backups, and logs.
- **Amazon EBS** provides persistent block storage for EC2 instances.
- **Amazon EFS** offers a shared file system that multiple EC2 instances can access simultaneously.

Choosing the correct storage service is essential for performance, scalability, and cost optimization.

---

# 🏗️ Architecture

```text
                           Users
                             │
                             ▼
                    Application Load Balancer
                             │
            ┌────────────────┴────────────────┐
            │                                 │
            ▼                                 ▼
       EC2 Instance A                    EC2 Instance B
            │                                 │
            │                                 │
            └───────────────┬─────────────────┘
                            │
                            ▼
                    Amazon EFS File System
                 (Shared Uploads & Documents)

      EC2 Root Volume
             │
             ▼
      Amazon EBS Volume
 (Operating System & Application)

Application Uploads
        │
        ▼
 Amazon S3 Bucket
 Images • Videos • Backups • Logs
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon S3 | Object storage for images, backups, logs, and static files |
| Amazon EBS | Persistent block storage attached to EC2 |
| Amazon EFS | Shared network file system for multiple EC2 instances |

---

# 🛒 Real-World Scenario

An online shopping application stores different types of data:

### Amazon S3

Stores

- Product Images
- Customer Uploads
- Backup Files
- Application Logs

### Amazon EBS

Stores

- Linux Operating System
- Installed Software
- Application Code
- Temporary Application Data

### Amazon EFS

Stores

- Uploaded Documents
- Product Images
- Shared Files
- Reports

Multiple EC2 instances can read and write the same files simultaneously.

---

# Storage Flow

```text
Customer Uploads Image
          │
          ▼
Application (EC2)
          │
          ├────────────► Amazon S3
          │              Store Images
          │
          ├────────────► Amazon EBS
          │              Store OS & Application
          │
          └────────────► Amazon EFS
                         Shared Files
```

---

# 1️⃣ Amazon S3 (Simple Storage Service)

## What is Amazon S3?

Amazon S3 is an object storage service designed for virtually unlimited scalability and high durability.

Objects are stored inside buckets.

Amazon S3 is commonly used for:

- Images
- Videos
- Documents
- Backups
- Terraform State Files
- Application Logs
- Static Websites

---

## Real-Time Example

An e-commerce application stores:

```
Product Images

Invoices (PDF)

Customer Uploads

Application Backups

CloudTrail Logs
```

Instead of storing images on EC2, they are uploaded to S3.

This reduces storage usage on application servers.

---

## Terraform

```hcl
resource "aws_s3_bucket" "app_bucket" {

  bucket = "company-production-assets"

  tags = {
    Name = "Application Assets"
  }

}
```

---

## Enable Versioning

```hcl
resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {

    status = "Enabled"

  }

}
```

---

## Best Practices

- Enable Versioning.
- Enable Server-Side Encryption.
- Block Public Access.
- Use Lifecycle Policies.
- Enable Access Logging.

---

# 2️⃣ Amazon EBS (Elastic Block Store)

## What is Amazon EBS?

Amazon EBS is block storage attached to an EC2 instance.

It behaves like a hard disk.

Each EC2 instance boots from an EBS volume.

---

## Real-Time Example

EC2 stores:

- Amazon Linux
- Java
- Node.js
- Docker
- Nginx
- Application Code

If the EC2 instance restarts, the EBS volume remains attached and data persists.

---

## Architecture

```text
EC2 Instance
      │
      ▼
 Amazon EBS Volume
      │
      ▼
Operating System

Application Code

Installed Software

Logs
```

---

## Terraform

```hcl
resource "aws_ebs_volume" "app_data" {

  availability_zone = "ap-south-1a"

  size = 30

  type = "gp3"

  encrypted = true

}
```

---

## Best Practices

- Encrypt all EBS volumes.
- Use GP3 for general-purpose workloads.
- Create regular snapshots.
- Delete unused volumes.

---

# 3️⃣ Amazon EFS (Elastic File System)

## What is Amazon EFS?

Amazon EFS is a managed network file system that multiple EC2 instances can mount at the same time.

Unlike EBS, EFS supports concurrent access from multiple instances.

---

## Real-Time Example

Two web servers serve the same website.

When a user uploads a file:

```
EC2-A

or

EC2-B
```

Both servers immediately see the uploaded file because it is stored on Amazon EFS.

This is ideal for:

- Shared Uploads
- CMS Platforms
- WordPress
- Media Files
- Reports

---

## Architecture

```text
             EC2-A
               │
               │
               ▼
        Amazon EFS
               ▲
               │
               │
             EC2-B
```

---

## Terraform

```hcl
resource "aws_efs_file_system" "shared_storage" {

  creation_token = "production-efs"

  encrypted = true

}
```

---

## Best Practices

- Enable Encryption.
- Create Mount Targets in every Availability Zone.
- Use Security Groups to restrict NFS access (Port 2049).
- Enable automatic backups.

---

# Storage Comparison

| Feature | Amazon S3 | Amazon EBS | Amazon EFS |
|----------|-----------|------------|------------|
| Storage Type | Object Storage | Block Storage | File Storage |
| Attach to EC2 | ❌ | ✅ | ✅ |
| Multiple EC2 Access | ❌ | ❌ | ✅ |
| Internet Accessible | ✅ (via APIs) | ❌ | ❌ |
| Use Cases | Images, Backups, Logs | Operating System, Databases, Applications | Shared Files, Uploads, CMS |

---

# Storage Workflow

```text
User Uploads Image
        │
        ▼
Application (EC2)
        │
        ├──────────────► Amazon S3
        │                 Product Images
        │
        ├──────────────► Amazon EBS
        │                 OS & Application
        │
        └──────────────► Amazon EFS
                          Shared Uploads
```

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon S3
- Amazon EBS
- Amazon EFS
- Object Storage
- Block Storage
- Shared File Systems
- Data Persistence
- Storage Best Practices
- Backup Strategies

---

# ✅ Interview Questions

### Why do we use Amazon S3?

Amazon S3 is used for storing unstructured data such as images, videos, backups, logs, and static website assets. It offers high durability, scalability, and cost efficiency.

---

### What is the difference between Amazon EBS and Amazon EFS?

Amazon EBS is block storage that can be attached to a single EC2 instance within the same Availability Zone.

Amazon EFS is a shared file system that multiple EC2 instances across multiple Availability Zones can access simultaneously.

---

### Can multiple EC2 instances attach to the same EBS volume?

Generally, no. Standard EBS volumes are designed to be attached to one EC2 instance at a time (with limited exceptions for specific Multi-Attach volume types).

---

### When should you choose Amazon EFS?

Use Amazon EFS when multiple application servers need concurrent access to the same files, such as shared uploads, CMS content, or media assets.

---

### Why should S3 Versioning be enabled?

Versioning protects against accidental deletion or overwriting of objects by preserving previous versions, making recovery straightforward.

---

# 🏆 Production Best Practices

- Store static content in Amazon S3 instead of on EC2 instances.
- Enable Versioning, Encryption, and Lifecycle Policies for S3 buckets.
- Encrypt all EBS volumes and create regular snapshots.
- Use GP3 volumes for most workloads.
- Mount Amazon EFS only where shared storage is required.
- Restrict EFS access using Security Groups and NFS port 2049.
- Use IAM Roles for secure access to S3 rather than embedding AWS access keys.
- Implement backup and retention policies for all storage services.
