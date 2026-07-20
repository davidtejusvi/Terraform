**Networking**
- VPC
- Internet Gateway
- Public Subnets
- Private App Subnets
- Private DB Subnets
- NAT Gateway
- Route Tables

**What you'll learn**

- CIDR planning
- Public vs. private networking
- Routing
- Internet connectivity

The CIDR block **`10.0.0.0/16`** contains:

- **Total IP addresses:** **65,536**
- **Usable IP addresses (theoretically):** **65,534** (excluding network and broadcast addresses)

### Calculation

- IPv4 has **32 bits**.
- A **`/16`** network uses **16 bits** for the network and **16 bits** for hosts.

```
Host bits = 32 - 16 = 16

Total IPs = 2^16
          = 65,536
```

### AWS VPC Note

If you're using `10.0.0.0/16` as an **AWS VPC CIDR**:

- The VPC has **65,536 total IP addresses**.
- AWS reserves **5 IP addresses in every subnet**, not the entire VPC.

For example:

|Subnet|Total IPs|AWS Reserved|Usable|
|---|---|---|---|
|`/24`|256|5|251|
|`/25`|128|5|123|
|`/26`|64|5|59|
|`/27`|32|5|27|
|`/28`|16|5|11|

### Example

A `10.0.0.0/16` VPC can be split into:

If your VPC CIDR is **`10.0.0.0/16`**, then asking about **`/16`** means you're not subdividing it at all.

|Subnet Size|Number of Subnets from `10.0.0.0/16`|
|---|---|
|`/16`|**1**|
|`/17`|2|
|`/18`|4|
|`/19`|8|
|`/20`|16|
|`/21`|32|
|`/22`|64|
|`/23`|128|
|`/24`|256|
|`/25`|512|
|`/26`|1,024|

### Formula

```
Number of Subnets = 2^(New Prefix - Original Prefix)
```

For example:

- `/16` → `2^(16-16) = 2^0 = 1`
- `/17` → `2^(17-16) = 2`
- `/18` → `2^(18-16) = 4`
- `/20` → `2^(20-16) = 16`
- `/24` → `2^(24-16) = 256`

### Examples

If your VPC is `10.0.0.0/16`:

- **/16 (1 subnet)**
    
    ```
    10.0.0.0/16
    ```
    
- **/17 (2 subnets)**
    
    ```
    10.0.0.0/17
    10.0.128.0/17
    ```
    
- **/18 (4 subnets)**
    
    ```
    10.0.0.0/18
    10.0.64.0/18
    10.0.128.0/18
    10.0.192.0/18
    ```
    
- **/24 (256 subnets)**
    
    ```
    10.0.0.0/24
    10.0.1.0/24
    10.0.2.0/24
    ...
    10.0.255.0/24
    ```
    

A simple way to remember it is: **every time you increase the prefix length by 1 (e.g., `/16` → `/17`), you double the number of subnets and halve the size of each subnet.**
A common AWS production setup is to create a **`10.0.0.0/16` VPC** and divide it into multiple `/24` subnets (for example, public, private application, and private database subnets across multiple Availability Zones).


# 🚀 Phase 1 — AWS Networking

## 🎯 Goal

In this phase, we'll build a secure and scalable AWS network using Terraform.

A well-designed network is the foundation of every AWS infrastructure. Before deploying EC2 instances, databases, or Kubernetes clusters, you must first create a Virtual Private Cloud (VPC) and configure networking components.

---

# 🏗️ Architecture

```text
                              Internet
                                  │
                                  │
                          Internet Gateway
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
            Public Route Table          Private Route Table
                    │                           │
        ┌───────────┴───────────┐               │
        │                       │               │
 Public Subnet A          Public Subnet B       │
        │                       │               │
        │                       │               │
     NAT Gateway             Load Balancer      │
        │                                       │
        └───────────────────┐                   │
                            │                   │
          ┌─────────────────┴─────────────────┐
          │                                   │
    Private App Subnet A               Private App Subnet B
          │                                   │
         EC2                                 EC2
          │                                   │
          └───────────────┬───────────────────┘
                          │
          ┌───────────────┴────────────────┐
          │                                │
   Private DB Subnet A              Private DB Subnet B
          │                                │
         Amazon RDS (Multi-AZ Database)
```

---

# 📖 Services Used

| AWS Service | Purpose |
|------------|---------|
| VPC | Creates an isolated network inside AWS |
| Internet Gateway | Allows internet access for public resources |
| Public Subnet | Hosts internet-facing resources |
| Private App Subnet | Hosts application servers |
| Private DB Subnet | Hosts databases |
| NAT Gateway | Allows private resources to access the internet securely |
| Route Tables | Controls network traffic |

---

# 1️⃣ Amazon VPC

## What is VPC?

A Virtual Private Cloud (VPC) is your own isolated network inside AWS where you can launch AWS resources securely.

Think of it as your company's private data center in the cloud.

### Real-Time Example

An e-commerce company creates one VPC for its production environment.

Inside the VPC:

- Public Subnets host the Load Balancer.
- Private App Subnets host EC2 instances.
- Private DB Subnets host Amazon RDS.

This prevents direct internet access to application servers and databases.

### Terraform

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPC"
  }
}
```

### Best Practices

- One VPC per environment
- Enable DNS Hostnames
- Plan CIDR ranges before deployment
- Avoid overlapping CIDR blocks
