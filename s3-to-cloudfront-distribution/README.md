# Terraform AWS S3 Private Bucket with CloudFront Distribution

This Terraform project creates a **private Amazon S3 bucket** and serves its content securely through an **Amazon CloudFront distribution** using **Origin Access Control (OAC)**.

The S3 bucket is not publicly accessible. Only CloudFront can access the objects stored in S3.

---

## Architecture


            User
             |
             |
          HTTPS
             |
             v
    CloudFront Distribution
    dxxxx.cloudfront.net
             |
             |
    Origin Access Control (OAC)
    AWS SigV4 Authentication
             |
             v
    Private S3 Bucket
    s3-cdf-private-bucket-demo


---

## Features

- Creates an S3 bucket using Terraform
- Blocks all public access to S3
- Enables S3 bucket ownership controls
- Creates CloudFront Origin Access Control (OAC)
- Creates CloudFront distribution
- Configures S3 as CloudFront origin
- Allows only CloudFront to read S3 objects
- Enables HTTPS redirect
- Supports static file delivery through CloudFront

---

## Project Structure


terraform-s3-cloudfront/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
└── README.md


---

# Prerequisites

Before running this Terraform code, install:

- Terraform
- AWS CLI
- AWS account with required permissions

Verify:

```bash
terraform version

aws --version

Configure AWS credentials:
aws configure

Terraform Deployment
1. Initialize Terraform
terraform init

2. Validate configuration
terraform validate

Expected:
Success! The configuration is valid.

3. Format Terraform files
terraform fmt

4. Review deployment plan
terraform plan

5. Create AWS resources
terraform apply

Type:
yes

Resources Created
S3 Bucket
Terraform creates:
aws_s3_bucket.my_private_s3_cdf_bucket

Configuration:
Private bucket
Public access blocked
Bucket owner enforced
Public access settings:
BlockPublicAcls       = true
BlockPublicPolicy     = true
IgnorePublicAcls      = true
RestrictPublicBuckets = true

CloudFront Distribution
Terraform creates:
aws_cloudfront_distribution.cdn

Features:
HTTPS enabled
HTTP redirected to HTTPS
S3 configured as origin
Origin Access Control enabled
CloudFront Origin Access Control
Terraform creates:
aws_cloudfront_origin_access_control.s3_oac

Authentication:
AWS Signature Version 4

CloudFront uses OAC to securely access private S3 objects.
Upload Test Content
Create a sample file:
cat > index.html <<EOF
<html>
<body>
<h1>Hello from Private S3 CloudFront</h1>
<p>S3 bucket is private.</p>
</body>
</html>
EOF

Upload:
aws s3 cp index.html s3://<bucket-name>/

Example:
aws s3 cp index.html s3://s3-cdf-private-bucket-demo/

Access Content Through CloudFront
Get CloudFront URL:
terraform output cloudfront_domain_name

Example:
d1l3kvy68luqy1.cloudfront.net

Access:
https://d1l3kvy68luqy1.cloudfront.net/index.html

Expected:
Hello from Private S3 CloudFront

Verify S3 is Private
Direct S3 access should fail:
curl -I https://s3-cdf-private-bucket-demo.s3.ap-south-1.amazonaws.com/index.html

Expected:
HTTP/2 403

CloudFront access should succeed:
curl -I https://d1l3kvy68luqy1.cloudfront.net/index.html

Expected:
HTTP/2 200

Terraform Outputs
Example:
cloudfront_distribution_id = E1GITDLLFI6N3S

cloudfront_domain_name = d1l3kvy68luqy1.cloudfront.net

s3_bucket_name = s3-cdf-private-bucket-demo

s3_bucket_arn = arn:aws:s3:::s3-cdf-private-bucket-demo

Destroy Resources
To remove all AWS resources:
terraform destroy

Confirm:
yes

Security Design
This implementation follows AWS recommended security practices:
No public S3 access
No S3 website endpoint exposure
CloudFront-only access
IAM-based authorization through OAC
HTTPS-only viewer access
