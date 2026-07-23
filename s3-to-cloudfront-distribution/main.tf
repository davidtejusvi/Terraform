# Create Private S3 Bucket
resource "aws_s3_bucket" "my_private_s3_cdf_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}


# Block Public Access
resource "aws_s3_bucket_public_access_block" "block_public" {

  bucket = aws_s3_bucket.my_private_s3_cdf_bucket.id

  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
}


# Enable Bucket Owner Control
resource "aws_s3_bucket_ownership_controls" "ownership" {

  bucket = aws_s3_bucket.my_private_s3_cdf_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}




# Create CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "s3_oac" {

  name = "s3-cloudfront-oac"

  description = "CloudFront access to private S3 bucket"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"

  signing_protocol = "sigv4"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {

  enabled = true

  default_root_object = "index.html"

  comment = "Private S3 bucket CloudFront distribution"


  origin {

    domain_name = aws_s3_bucket.my_private_s3_cdf_bucket.bucket_regional_domain_name

    origin_id = "s3-${aws_s3_bucket.my_private_s3_cdf_bucket.id}"

    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id

  }


  default_cache_behavior {

    target_origin_id = "s3-${aws_s3_bucket.my_private_s3_cdf_bucket.id}"

    viewer_protocol_policy = "redirect-to-https"


    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    compress = true


    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }
    }
  }


  restrictions {

    geo_restriction {

      restriction_type = "none"

    }
  }


  viewer_certificate {

    cloudfront_default_certificate = true

  }


  price_class = "PriceClass_100"
}





resource "aws_s3_bucket_policy" "cloudfront_access" {

  bucket = aws_s3_bucket.my_private_s3_cdf_bucket.id


  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "AllowCloudFrontRead"

        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.my_private_s3_cdf_bucket.arn}/*"

        Condition = {

          StringEquals = {

            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn

          }

        }

      }

    ]

  })
}
