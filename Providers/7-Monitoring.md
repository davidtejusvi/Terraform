
# 📊 Phase 7 — Monitoring & Alerting

## 🎯 Goal

Monitor the health and performance of AWS resources using **Amazon CloudWatch** and notify the operations team using **Amazon SNS**.

Monitoring helps detect issues before they impact users and enables automated responses to maintain application availability.

---

# 🏗️ Architecture

```text
                    EC2 Instance
                         │
        CPU • Memory • Disk • Network
                         │
                         ▼
                 Amazon CloudWatch
                         │
              CloudWatch Alarm
              CPU Utilization > 80%
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
     Amazon SNS                 Auto Scaling Group
          │                             │
          ▼                             ▼
 DevOps Email Alert         Launch New EC2 Instance
```

---

# 📖 Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon CloudWatch | Monitors AWS resources and applications |
| CloudWatch Alarm | Triggers actions when metrics exceed thresholds |
| Amazon SNS | Sends notifications via Email, SMS, Lambda, or SQS |

---

# 🛒 Real-World Scenario

An e-commerce application runs on multiple EC2 instances.

During a flash sale:

- Thousands of customers visit the website.
- CPU utilization increases above **80%**.
- CloudWatch detects the threshold breach.
- CloudWatch Alarm changes to the **ALARM** state.
- Amazon SNS immediately sends an email to the DevOps team.
- Auto Scaling launches additional EC2 instances to handle increased traffic.
- Once traffic decreases, Auto Scaling terminates the extra instances.

This ensures the application remains available without manual intervention.

---

# Request Flow

```text
Customer Requests
        │
        ▼
EC2 Instance
        │
        ▼
CPU Usage = 85%
        │
        ▼
Amazon CloudWatch
        │
        ▼
CloudWatch Alarm
        │
        ├────────────► Amazon SNS
        │                 │
        │                 ▼
        │           Email DevOps Team
        │
        ▼
Auto Scaling Group
        │
        ▼
Launch New EC2 Instance
```

---

# 1️⃣ Amazon CloudWatch

## What is Amazon CloudWatch?

Amazon CloudWatch is AWS's monitoring and observability service.

It continuously collects metrics and logs from AWS resources.

CloudWatch monitors:

- CPU Utilization
- Memory Usage (CloudWatch Agent)
- Disk Usage
- Network Traffic
- Application Logs
- Custom Metrics

---

## Real-Time Example

Monitor an EC2 instance.

If:

```
CPU > 80%
```

CloudWatch automatically creates an alarm and triggers predefined actions.

---

## Terraform

```hcl
resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name          = "HighCPU"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2

  metric_name         = "CPUUtilization"

  namespace           = "AWS/EC2"

  period              = 300

  statistic           = "Average"

  threshold           = 80

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

}
```

---

# 2️⃣ Amazon SNS

## What is Amazon SNS?

Amazon SNS (Simple Notification Service) is a fully managed messaging service.

It delivers notifications to:

- Email
- SMS
- Lambda
- SQS
- HTTPS Endpoints

---

## Real-Time Example

CloudWatch detects:

```
CPU = 87%
```

SNS immediately sends:

```
Subject:

Production Alert

Message:

EC2 CPU utilization exceeded 80%.

Current CPU: 87%

Time: 10:15 AM UTC

Please investigate.
```

The DevOps team receives the email within seconds.

---

## Terraform

```hcl
resource "aws_sns_topic" "alerts" {

  name = "production-alerts"

}

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol  = "email"

  endpoint  = "devops@example.com"

}
```

---

# Monitoring Workflow

```text
EC2
 │
 ▼
CloudWatch
 │
 ▼
CPU > 80%
 │
 ▼
CloudWatch Alarm
 │
 ├──────────────► SNS
 │                  │
 │                  ▼
 │          Email DevOps Team
 │
 ▼
Auto Scaling
 │
 ▼
Launch New EC2
```

---

# 🎓 What You'll Learn

After completing this phase, you'll understand:

- Amazon CloudWatch
- CloudWatch Metrics
- CloudWatch Alarms
- Amazon SNS
- Infrastructure Monitoring
- Email Notifications
- Performance Monitoring
- Incident Response

---

# ✅ Interview Questions

### Why do we use CloudWatch?

CloudWatch monitors AWS resources, collects metrics and logs, and generates alarms when performance thresholds are exceeded.

---

### What happens when CPU exceeds 80%?

CloudWatch changes the alarm state to **ALARM**, sends an SNS notification, and can optionally trigger an Auto Scaling policy to launch additional EC2 instances.

---

### Why use SNS?

SNS provides immediate notifications to the operations team, helping engineers respond quickly to production issues.

---

### Can CloudWatch trigger Auto Scaling?

Yes.

CloudWatch Alarms can trigger Auto Scaling policies to automatically increase or decrease the number of EC2 instances based on application demand.

---

# 🏆 Production Best Practices

- Enable Detailed Monitoring for EC2.
- Install the CloudWatch Agent for memory and disk metrics.
- Create alarms for CPU, memory, disk, and network utilization.
- Send alerts through SNS.
- Integrate CloudWatch with Auto Scaling.
- Build CloudWatch Dashboards for infrastructure visibility.
- Configure log retention policies to manage storage costs.
