variable "aws_region" {
  description = "aws region name"
  type        = string
}

variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
}

variable "s3_block_public_acls" {
  type = bool
}

variable "s3_block_public_policy" {
  type = bool
}

variable "s3_ignore_public_acls" {
  type = bool
}

variable "s3_restrict_public_buckets" {
  type = bool
}
