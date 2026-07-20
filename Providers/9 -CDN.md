# 🌍 Phase 9 — Content Delivery Network (CDN)

## 🎯 Goal

In this phase, we'll use **Amazon CloudFront** to deliver static and dynamic content with low latency.

Instead of every user accessing resources from a single AWS Region, CloudFront caches content at AWS Edge Locations around the world. This reduces response time, improves website performance, and decreases the load on the origin server.

CloudFront is commonly used with:

- Amazon S3
- Application Load Balancer (ALB)
- EC2
- API Gateway

---

# 🏗️ Architecture

```text
                      Users Worldwide
        USA       Europe       India      Australia
          │           │            │            │
          └───────────┴────────────┴────────────┘
                              │
                              ▼
                  Amazon CloudFront
                  (Global Edge Locations)
                              │
               Cached Images, CSS, JavaScript
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
        Amazon S3                    Application Load Balancer
    (Static Content)                    (Dynamic Content)
                                              │
                                              ▼
                                        EC2 Instances
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon CloudFront | Global Content Delivery Network (CDN) |
| Amazon S3 | Stores static website assets |
| Application Load Balancer | Serves dynamic application requests |
| EC2 | Hosts the application |

---

# 🛒 Real-World Scenario

An e-commerce website is hosted in the **Mumbai (ap-south-1)** Region.

Customers visit the website from:

- India
- United States
- Germany
- Australia

Without CloudFront:

Every request travels to the Mumbai Region, increasing latency for users who are far away.

With CloudFront:

- Images
- CSS
- JavaScript
- Videos

are cached at the nearest AWS Edge Location.

Result:

- Faster page loads
- Lower latency
- Reduced origin server load
- Improved user experience

---

# Request Flow

```text
User Browser
       │
       ▼
https://www.company.com
       │
       ▼
Amazon CloudFront
       │
   Cache Hit?
   │         │
 Yes        No
 │           │
 ▼           ▼
Serve     Fetch from Origin
Cached         │
Content        ▼
          Amazon S3 / ALB
```

---

# 1️⃣ Amazon CloudFront

## What is Amazon CloudFront?

Amazon CloudFront is AWS's global Content Delivery Network (CDN).

It delivers content from the AWS Edge Location closest to the user, reducing latency and improving performance.

CloudFront supports:

- Static Websites
- Images
- CSS
- JavaScript
- Videos
- APIs
- Dynamic Web Applications

---

## Real-Time Example

A shopping website stores:

- Product Images
- CSS Files
- JavaScript Files
- Fonts

in Amazon S3.

CloudFront caches these files at global Edge Locations.

A user in London receives content from a nearby Edge Location instead of waiting for files to travel from the Mumbai Region.

---

## Terraform

```hcl
resource "aws_cloudfront_distribution" "cdn" {

  enabled = true

  origins {

    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name

    origin_id = "s3-origin"

  }

  default_cache_behavior {

    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]

    cached_methods = ["GET", "HEAD"]

  }

  viewer_certificate {

    cloudfront_default_certificate = true

  }

}
```

---

## Best Practices

- Use CloudFront for static assets.
- Enable HTTPS.
- Compress objects (Gzip/Brotli).
- Configure appropriate cache policies.
- Restrict direct access to the S3 bucket using Origin Access Control (OAC).

---

# 2️⃣ Edge Locations

## What are Edge Locations?

Edge Locations are AWS data centers distributed around the world.

CloudFront caches content at these locations.

When a user requests an object:

- If it exists in the Edge Location (**Cache Hit**), it is served immediately.
- Otherwise (**Cache Miss**), CloudFront retrieves it from the origin and caches it for future requests.

---

## Example

```text
Origin

Mumbai Region

        │

        ▼

CloudFront Edge Locations

London

Singapore

Tokyo

Sydney

New York
```

Users receive content from the nearest Edge Location.

---

# Cache Workflow

```text
User

 │

 ▼

CloudFront

 │

 ├──────── Cache Hit

 │              │

 │              ▼

 │        Serve Immediately

 │

 └──────── Cache Miss

                │

                ▼

Origin (S3 / ALB)

                │

                ▼

Store in Cache

                │

                ▼

Return to User
```

---

# Static vs Dynamic Content

| Content Type | Origin | Cached by CloudFront |
|--------------|--------|----------------------|
| Images | Amazon S3 | ✅ Yes |
| CSS | Amazon S3 | ✅ Yes |
| JavaScript | Amazon S3 | ✅ Yes |
| Videos | Amazon S3 | ✅ Yes |
| API Responses | ALB / API Gateway | Optional |
| HTML Pages | ALB | Depends on cache policy |

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon CloudFront
- Content Delivery Networks (CDN)
- Edge Locations
- Cache Hit and Cache Miss
- Origin Servers
- Static vs Dynamic Content
- Cache Policies
- Website Performance Optimization

---

# ✅ Interview Questions

### Why do we use Amazon CloudFront?

Amazon CloudFront reduces latency by serving content from the AWS Edge Location closest to the user, improving performance and reducing load on the origin server.

---

### What is an Origin in CloudFront?

An origin is the backend source from which CloudFront retrieves content, such as:

- Amazon S3
- Application Load Balancer
- EC2
- API Gateway

---

### What is a Cache Hit?

A Cache Hit occurs when the requested object is already stored at the Edge Location, allowing CloudFront to return it immediately without contacting the origin.

---

### What is a Cache Miss?

A Cache Miss occurs when the requested object is not cached. CloudFront fetches it from the origin, returns it to the user, and stores it in the cache for future requests.

---

### Can CloudFront work with dynamic applications?

Yes.

CloudFront can accelerate dynamic content served through an Application Load Balancer or API Gateway while also caching static assets based on configured cache policies.

---

# 🏆 Production Best Practices

- Use Amazon S3 as the origin for static assets.
- Use an Application Load Balancer or API Gateway for dynamic content.
- Restrict S3 bucket access using Origin Access Control (OAC).
- Configure cache policies based on application requirements.
- Enable HTTPS with an ACM certificate (issued in **us-east-1** for CloudFront).
- Enable compression (Gzip/Brotli) to reduce bandwidth usage.
- Monitor cache hit ratio using Amazon CloudWatch.
- Invalidate cached objects only when necessary to minimize costs.
