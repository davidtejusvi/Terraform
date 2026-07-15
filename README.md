# Terraform
Terraform


HashiCorp Terraform is an Infrastructure as Code (IaC) tool.

Used to create cloud infrastructure using code.

Supports:

- Amazon Web Services
- Microsoft Azure
- Google Cloud
- Kubernetes
- Docker

---

# 1. What is Terraform?

Instead of manually creating cloud resources:

```
Clicking in AWS console ❌
```

Use code:

```
Infrastructure using .tf files ✅
```

---

# 2. Infrastructure as Code (IaC)

IaC means managing infrastructure with code.

Benefits:

- Automation
- Reusability
- Version control
- Faster deployments

---

# 3. Terraform Workflow

```
Write Code   
↓
terraform init   
	↓
terraform plan   
	↓
terraform apply
```

---

# 4. Install Terraform

Check version:

```
terraform version
```

---

# 5. Basic Terraform File

Example:

```

provider "aws" {
  region = "ap-south-1"
}
```

---

# 6. Provider

Provider connects Terraform to cloud platforms.

Examples:

|Provider|Purpose|
|---|---|
|aws|AWS resources|
|azurerm|Azure|
|google|GCP|
|kubernetes|Kubernetes|

---

# 7. Resource

Resource creates infrastructure.

Example:

```

resource "aws_instance" "web" {
  instance_type = "t2.micro"
}
```

---

# 8. Terraform Commands

## Initialize

```
terraform init
```

Downloads provider plugins.

---

## Validate

```
terraform validate
```

Checks syntax.

---

## Plan

```
terraform plan
```

Shows changes before applying.

---

## Apply

```
terraform apply
```

Creates infrastructure.

---

## Destroy

```
terraform destroy
```

Deletes infrastructure.

---

# 9. Variables

Used for reusable code.

Example:

```
variable "region" {  default = "ap-south-1"}
```

Use:

```
region = var.region
```

---

# 10. Outputs

Displays useful information.

Example:

```
output "instance_ip" {  value = aws_instance.web.public_ip}
```

---

# 11. State File

Terraform stores infrastructure state in:

```
terraform.tfstate
```

Tracks created resources.

---

# 12. Remote Backend

Stores state remotely.

Common backend:

- S3 bucket in Amazon Web Services

Example:

```
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "prod.tfstate"
    region = "ap-south-1"
  }
}
```

---

# 13. Modules

Modules = reusable Terraform code.

Example:

```
VPC moduleEC2 moduleEKS module
```

---

# 14. Terraform with AWS

Common resources:

|Resource|Purpose|
|---|---|
|aws_instance|EC2|
|aws_s3_bucket|S3|
|aws_vpc|VPC|
|aws_security_group|Firewall|

---

# 15. Terraform with Kubernetes

Deploy Kubernetes resources.

Example:

```
provider "kubernetes" {  config_path = "~/.kube/config"}
```

---

# 16. Terraform Lifecycle

```
Write Code   ↓Plan   ↓Apply   ↓Update   ↓Destroy
```

---

# 17. Dependency Management

Terraform automatically handles dependencies.

Example:

```
VPC created before EC2
```

---

# 18. Terraform Best Practices

- Use modules
- Store remote state
- Use variables
- Avoid hardcoded values
- Use version control
- Separate environments

---

# 19. Important Interview Topics

1. Terraform workflow
2. Provider vs resource
3. State file
4. Remote backend
5. Variables & outputs
6. Modules
7. terraform plan vs apply
8. Terraform lifecycle
9. Terraform vs CloudFormation
10. Infrastructure as Code

# Terraform Important Interview Topics (Quick Revision)

---

# 1. Terraform Workflow

Terraform workflow:

```
Write Code   
↓
terraform init   
	↓
	terraform plan   
	↓
	terraform apply
```

---

## Commands

|Command|Purpose|
|---|---|
|terraform init|Initialize Terraform|
|terraform plan|Preview changes|
|terraform apply|Create/update infrastructure|
|terraform destroy|Remove infrastructure|

---

# 2. Provider vs Resource

---

## Provider

Provider connects Terraform to cloud/platform.

Example:

```
provider "aws" {  
	region = "ap-south-1"
}
```

---

## Resource

Resource creates actual infrastructure.

Example:

```
resource "aws_instance" "web" {  
	instance_type = "t2.micro"
	}
```

---

## Difference

|Provider|Resource|
|---|---|
|Connection plugin|Actual infrastructure|
|AWS/Azure/GCP|EC2/VPC/S3|

---

# 3. State File

Terraform stores infrastructure state in:

```
terraform.tfstate
```

---

## Purpose

Tracks:

- Existing resources
- Infrastructure changes
- Resource metadata

---

## Important Point

```
Terraform compares code with state file
```

---

# 4. Remote Backend

Used to store state remotely.

Common backend in Amazon Web Services:

- S3 bucket

---

## Example

```

terraform {
  backend "s3" {
    bucket = "tf-state"
    key    = "prod.tfstate"
    region = "ap-south-1"
  }
}
```

---

## Benefits

- Team sharing
- Backup
- State locking
- Better security

---

# 5. Variables & Outputs

---

# Variables

Reusable input values.

Example:

```
variable "region" {  
 default = "ap-south-1"
}
```

Use:

```
region = var.region
```

---

# Outputs

Display useful values.

Example:

```
output "public_ip" {  
	value = aws_instance.web.public_ip
	}
```

---

## Difference

|Variables|Outputs|
|---|---|
|Input|Output|
|User provides|Terraform displays|

---

# 6. Modules

Modules = reusable Terraform code blocks.

---

## Examples

```
VPC moduleEC2 moduleEKS module
```

---

## Benefits

- Reusable
- Cleaner structure
- Easier maintenance

---

## Usage

```
module "vpc" {  
	source = "./modules/vpc"
	}
```

---

# 7. terraform plan vs apply

|terraform plan|terraform apply|
|---|---|
|Preview changes|Execute changes|
|Safe review|Creates resources|

---

## Example

```
terraform plan

terraform apply
```

---

# 8. Terraform Lifecycle

```
Write 
↓
Init 
↓
Plan 
↓
Apply 
↓
Update 
↓
Destroy
```

---

# 9. Terraform vs CloudFormation

|Terraform|CloudFormation|
|---|---|
|Multi-cloud|AWS only|
|Open-source|AWS native|
|HCL language|JSON/YAML|
|Flexible|Deep AWS integration|

---

## Example

|Tool|Platforms|
|---|---|
|Terraform|AWS, Azure, GCP|
|CloudFormation|AWS only|

---

# 10. Infrastructure as Code (IaC)

IaC = managing infrastructure using code.

Instead of:

```
Manual cloud setup ❌
```

Use:

```
Automated infrastructure code ✅
```

---

## Benefits

|Benefit|Purpose|
|---|---|
|Automation|Faster setup|
|Version control|Track changes|
|Consistency|Same environment|
|Reusability|Reuse templates|

---

# Real DevOps Flow

```
Terraform   
↓
AWS Infrastructure   
↓
Docker   
↓
Kubernetes
```

# Terraform Important Interview Topics (Simple & Reliable)

---

# 1. Terraform Workflow

Basic Terraform process.

```
Write Code   
↓
terraform init   
↓
terraform plan   
↓
terraform apply
```

---

## Steps

|Command|Purpose|
|---|---|
|init|Initialize project|
|plan|Preview changes|
|apply|Create/update infrastructure|
|destroy|Delete infrastructure|

---

# 2. Provider vs Resource

---

## Provider

Provider connects Terraform to platform/services.

Examples:

- AWS
- Azure
- Kubernetes

Example:

```
provider "aws" {  
region = "ap-south-1"
}
```

---

## Resource

Resource creates infrastructure.

Example:

```
resource "aws_instance" "web" {  
	instance_type = "t2.micro"
}
```

---

## Difference

|Provider|Resource|
|---|---|
|Connects to platform|Creates actual infrastructure|
|aws, azurerm|EC2, VPC, S3|

---

# 3. State File

Terraform stores infrastructure state in:

```
terraform.tfstate
```

---

## Purpose

Tracks:

- Created resources
- Resource IDs
- Infrastructure changes

---

## Important Point

```
Terraform compares code with state file
```

---

# 4. Remote Backend

Stores state remotely for teams.

Most common backend in Amazon Web Services:

- S3 bucket

---

## Example

```

terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "prod.tfstate"
    region = "ap-south-1"
  }
}
```

---

## Benefits

- Team collaboration
- State locking
- Backup/security

---

# 5. Variables & Outputs

---

# Variables

Used for reusable code.

Example:

```


variable "region" {
  default = "ap-south-1"
}
```

Use:

```
region = var.region
```

---

# Outputs

Displays useful values.

Example:

```
output "public_ip" { 
	 value = aws_instance.web.public_ip
	 }
```

---

## Difference

|Variables|Outputs|
|---|---|
|Input values|Output values|
|User provides|Terraform displays|

---

# 6. Modules

Modules = reusable Terraform code.

---

## Example

```
VPC module
EC2 module
EKS module
```

---

## Benefits

- Reusability
- Cleaner code
- Standardization

---

## Usage

```
module "vpc" {  
		source = "./modules/vpc"
		}
```

---

# 7. terraform plan vs apply

|plan|apply|
|---|---|
|Preview changes|Execute changes|
|Safe check|Creates infrastructure|

---

## Plan Example

```
terraform plan
```

Shows:

```
+ create
  ~ modify
  - destroy
```

---

## Apply Example

```
terraform apply
```

Actually creates resources.

---

# 8. Terraform Lifecycle

```
Write Code   
↓
Init   
↓
Plan   
↓
Apply   
↓
Update   
↓
Destroy
```

---

# 9. Terraform vs CloudFormation

|Terraform|CloudFormation|
|---|---|
|Multi-cloud|AWS only|
|Open-source|AWS native|
|Uses HCL|Uses JSON/YAML|
|More flexible|Deep AWS integration|

---

## Example

|Tool|Supports|
|---|---|
|Terraform|AWS, Azure, GCP|
|CloudFormation|AWS only|

---

# 10. Infrastructure as Code (IaC)

IaC = managing infrastructure using code.

Instead of:

```
Manual cloud setup ❌
```

Use:

```
Automated infrastructure code ✅
```

---

## Benefits

|Benefit|Meaning|
|---|---|
|Automation|Faster setup|
|Version control|Track changes|
|Reusability|Reuse code|
|Consistency|Same infrastructure|

---

# Real Terraform Flow

```
Terraform Code    
↓
AWS Infrastructure    
↓
EC2 / VPC / EKS
```

---

# 20. Simple AWS EC2 Example

```

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

Apply:

```
terraform initterraform apply
```

---

# Real DevOps Flow

```
Terraform   
↓
AWS Infrastructure   
↓
Docker   
↓
Kubernetes   
↓
Application Deployment
```

---

# Best Learning Order

1. Terraform basics
2. Providers & resources
3. Variables
4. Outputs
5. State management
6. Remote backend
7. Modules
8. AWS infrastructure
9. Kubernetes deployment
10. CI/CD integration
