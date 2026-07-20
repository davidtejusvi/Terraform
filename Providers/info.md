# Terraform + AWS Quick Notes (Simple & Easy)

---

# 1. `terraform init`

### What it does

* Initializes the Terraform project.
* Downloads required provider plugins.
* Creates the `.terraform` directory.

Run this once when starting a project or after changing providers/backends.

```bash
terraform init
```

---

# 2. Provider

### Purpose

A provider tells Terraform **which cloud platform** to manage.

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

# 3. Resource Block

### Purpose

A resource block defines **what Terraform should create**.

**Syntax**

```hcl
resource "<RESOURCE_TYPE>" "<LOCAL_NAME>" {

}
```

Example

```hcl
resource "aws_instance" "webserver" {
  ami           = "ami-0b910d1016287a5e7"
  instance_type = "t3.micro"

  tags = {
    Name = "WebServer"
  }
}
```

* **Resource Type** → `aws_instance`
* **Local Name** → `webserver`
* **Arguments** → `ami`, `instance_type`, `tags`

---

# 4. S3 Bucket

```hcl
resource "aws_s3_bucket" "bucket" {
  bucket = "my-demo-bucket-12345"
}
```

Creates an S3 bucket.

---

# 5. Output Values

### Purpose

Displays useful information after `terraform apply`.

```hcl
output "public_ip" {
  value = aws_instance.webserver.public_ip
}
```

Hide sensitive data:

```hcl
output "password" {
  value     = "secret"
  sensitive = true
}
```

View outputs:

```bash
terraform output
terraform output -json
```

---

# 6. `count`

### Purpose

Creates multiple identical resources.

```hcl
resource "aws_instance" "web" {
  count = 2

  ami           = "ami-0b910d1016287a5e7"
  instance_type = "t3.micro"

  tags = {
    Name = "Web-${count.index + 1}"
  }
}
```

Creates:

* Web-1
* Web-2

---

# 7. `for_each`

### Purpose

Creates resources using a map or set.

```hcl
locals {
  servers = {
    dev  = "t3.micro"
    uat  = "t3.small"
    prod = "t3.large"
  }
}

resource "aws_instance" "server" {
  for_each = local.servers

  ami           = "ami-0b910d1016287a5e7"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```

Creates:

* dev
* uat
* prod

---

# 8. `toset()`

```hcl
resource "aws_instance" "server" {
  for_each = toset(["dev","uat","prod"])

  ami           = "ami-0b910d1016287a5e7"
  instance_type = "t3.micro"

  tags = {
    Name = each.key
  }
}
```

Creates one EC2 for each environment.

---

# 9. `depends_on`

### Purpose

Forces Terraform to create one resource before another.

```hcl
resource "aws_instance" "web" {
  ...
}

resource "aws_s3_bucket" "bucket" {
  bucket = "demo-bucket"

  depends_on = [
    aws_instance.web
  ]
}
```

EC2 is created first, then the S3 bucket.

---

# 10. Multiple Providers (Alias)

### Purpose

Deploy to multiple AWS accounts or regions.

```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
```

Use the alias:

```hcl
resource "aws_instance" "usa" {
  provider = aws.virginia

  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

---

# 11. `create_before_destroy`

### Purpose

Creates a new resource before deleting the old one, reducing downtime.

```hcl
lifecycle {
  create_before_destroy = true
}
```

---

# 12. `ignore_changes`

### Purpose

Ignores selected changes made outside Terraform.

```hcl
lifecycle {
  ignore_changes = [
    instance_type,
    tags
  ]
}
```

Terraform won't modify those fields.

---

# 13. Provisioners

## a) File

Copies files to the remote server.

## b) Local Exec

Runs commands on your local machine.

```hcl
provisioner "local-exec" {
  command = "echo Hello"
}
```

## c) Remote Exec

Runs commands on the EC2 instance.

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo yum install httpd -y",
    "sudo systemctl start httpd"
  ]
}
```

---

# 14. User Data

### Purpose

Runs commands automatically during EC2 launch.

```hcl
resource "aws_instance" "web" {
  user_data = file("${path.module}/userdata.sh")
}
```

Preferred over `remote-exec` for bootstrapping.

---

# 15. Remote Backend (S3)

### Purpose

Stores the Terraform state remotely for team collaboration.

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-demo"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"

    use_lockfile = true
  }
}
```

Best practices:

* Enable S3 Versioning
* Enable Object Lock (Compliance Mode)

---

# 16. Common Terraform Commands

Format code

```bash
terraform fmt
```

Validate syntax

```bash
terraform validate
```

Preview changes

```bash
terraform plan
```

Create resources

```bash
terraform apply
```

Auto approve

```bash
terraform apply --auto-approve
```

Destroy resources

```bash
terraform destroy
```

Destroy without confirmation

```bash
terraform destroy --auto-approve
```

---

# 17. Terraform State

### Purpose

Stores the current state of your infrastructure.

**Remember**

* Source of Truth
* Never edit manually
* Never commit to GitHub

Useful commands

```bash
terraform state list
terraform state show aws_instance.webserver
```

---

# 18. Replace a Resource

Recreate a resource without changing code.

```bash
terraform plan -replace="aws_instance.webserver"

terraform apply -replace="aws_instance.webserver"
```

---

# 19. Drift Detection

Check for manual changes in AWS.

Detect only

```bash
terraform plan -refresh-only
```

Update state

```bash
terraform apply -refresh-only
```

Revert manual changes

```bash
terraform apply
```

---

# 20. Terraform Logs

Enable logging

```bash
export TF_LOG=INFO
```

Other levels

```text
ERROR
WARN
INFO
DEBUG
TRACE
```

Save logs

```bash
export TF_LOG_PATH="terraform.log"
```

Disable logs

```bash
unset TF_LOG
```

---

# 21. Parallel Resource Creation

Default parallelism is **10**.

Change it:

```bash
terraform apply -parallelism=5
```

---

# 22. Local Backend

Stores the state on your computer.

```hcl
terraform {
  backend "local" {
    path = "/path/to/terraform.tfstate"
  }
}
```

Move state to a new backend:

```bash
terraform init -migrate-state
```

---

# 23. VS Code Extension

Install the **HashiCorp Terraform** extension for:

* Syntax highlighting
* Auto-completion
* Formatting
* Validation

---

# Quick Revision Table

| Topic                   | Purpose                                |
| ----------------------- | -------------------------------------- |
| `terraform init`        | Initialize project                     |
| Provider                | Connect to AWS                         |
| Resource                | Create AWS resources                   |
| Output                  | Display resource values                |
| `count`                 | Create identical resources             |
| `for_each`              | Create resources from a map or set     |
| `depends_on`            | Control creation order                 |
| Alias Provider          | Use multiple regions/accounts          |
| `create_before_destroy` | Reduce downtime during replacement     |
| `ignore_changes`        | Ignore selected external changes       |
| User Data               | Configure EC2 at launch                |
| `remote-exec`           | Run commands on EC2 after creation     |
| State File              | Tracks managed infrastructure          |
| S3 Backend              | Store state remotely                   |
| Drift Detection         | Detect or reconcile manual AWS changes |
| `terraform fmt`         | Format code                            |
| `terraform validate`    | Check syntax                           |
| `terraform plan`        | Preview changes                        |
| `terraform apply`       | Apply changes                          |
| `terraform destroy`     | Delete infrastructure                  |
