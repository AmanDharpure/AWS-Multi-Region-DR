

# 🌍 AWS Multi-Region Disaster Recovery Architecture

### Production-Grade Disaster Recovery Solution using Terraform & AWS

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?style=for-the-badge&logo=terraform)
![Route53](https://img.shields.io/badge/Route53-DNS-red?style=for-the-badge)
![CloudWatch](https://img.shields.io/badge/CloudWatch-Monitoring-blue?style=for-the-badge)
![SNS](https://img.shields.io/badge/SNS-Alerts-yellow?style=for-the-badge)
![License](https://img.shields.io/github/license/AmanDharpure/AWS-Multi-Region-DR?style=for-the-badge)

---

Production-ready Disaster Recovery Architecture built on AWS using Terraform.

Designed to automatically recover workloads from a Regional Failure while maintaining High Availability, Scalability and Infrastructure as Code.

</div>

---

# 📖 Project Overview

This project demonstrates how enterprise applications can survive a complete AWS Regional outage using Infrastructure as Code and AWS-native Disaster Recovery services.

The architecture deploys identical infrastructure in two AWS Regions.

- **Primary Region:** us-east-1
- **Disaster Recovery Region:** us-west-2

If the primary region becomes unavailable, traffic automatically fails over to the DR region using Amazon Route53.

---

# 🏗 AWS Architecture

```mermaid
flowchart LR

Users((Users))

Users --> R53

subgraph Primary Region (us-east-1)

R53[Route53]

ALB1[Application Load Balancer]

ASG1[Auto Scaling Group]

EC21[EC2 Instance 1]
EC22[EC2 Instance 2]

RDS1[(Primary Database)]

CW1[CloudWatch]

SNS1[SNS]

end

subgraph Disaster Recovery Region (us-west-2)

ALB2[Application Load Balancer]

ASG2[Auto Scaling Group]

EC23[EC2 Instance 1]
EC24[EC2 Instance 2]

RDS2[(Standby Database)]

CW2[CloudWatch]

SNS2[SNS]

end

S3[(S3 Cross Region Backup)]

CW1 --> SNS1
CW2 --> SNS2

ALB1 --> ASG1

ASG1 --> EC21
ASG1 --> EC22

ALB2 --> ASG2

ASG2 --> EC23
ASG2 --> EC24

RDS1 --> RDS2

RDS1 --> S3

RDS2 --> S3

R53 --> ALB1

R53 -.Failover.-> ALB2
```

---

# 🚀 Architecture Components

| Service | Purpose |
|----------|----------|
| Amazon VPC | Network Isolation |
| EC2 | Application Servers |
| Auto Scaling | High Availability |
| Application Load Balancer | Traffic Distribution |
| Route53 | DNS Failover |
| CloudWatch | Monitoring |
| SNS | Alert Notifications |
| Terraform | Infrastructure as Code |
| S3 | Backup Storage |
| IAM | Secure Access |

---

# 🌎 Disaster Recovery Workflow

```text
User

↓

Route53

↓

Primary Load Balancer

↓

Auto Scaling Group

↓

Application Servers

↓

Primary Database

↓

CloudWatch Health Check

↓

If Region Fails

↓

Route53 Failover

↓

Secondary Load Balancer

↓

Secondary Auto Scaling Group

↓

Secondary EC2

↓

Standby Database

↓

Application Restored
```

---

# ⚡ Features

✅ Multi Region Deployment

✅ Infrastructure as Code

✅ High Availability

✅ Disaster Recovery

✅ Route53 Automatic Failover

✅ Auto Scaling

✅ Application Load Balancer

✅ CloudWatch Monitoring

✅ SNS Email Alerts

✅ Cross Region Backups

---

# 📂 Repository Structure

```
AWS-Multi-Region-DR/

│

├── modules/

│ ├── vpc/

│ ├── alb/

│ ├── ec2/

│ ├── autoscaling/

│ ├── security-group/

│ └── monitoring/

│

├── environments/

│ ├── primary/

│ └── secondary/

│

├── screenshots/

├── diagrams/

├── README.md

└── terraform.tfvars

```

---

# 🛠 Tech Stack

- AWS EC2
- AWS VPC
- Route53
- Auto Scaling
- Application Load Balancer
- CloudWatch
- SNS
- IAM
- S3
- Terraform
- Git
- GitHub

---

# ⚙ Deployment

Clone repository

```bash
git clone https://github.com/AmanDharpure/AWS-Multi-Region-DR.git
```

Initialize Terraform

```bash
terraform init
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Deploy

```bash
terraform apply
```

Destroy

```bash
terraform destroy
```

---

# 📊 Monitoring

CloudWatch continuously monitors

- EC2 Health
- CPU Utilization
- Status Checks
- Auto Scaling
- Application Availability

When a failure occurs

CloudWatch

↓

SNS

↓

Email Notification

↓

Route53 Failover

↓

Traffic redirected to DR Region

---

# 📸 Project Screenshots

```
screenshots/

├── architecture.png

├── terraform-apply.png

├── route53.png

├── load-balancer.png

├── autoscaling.png

├── cloudwatch.png

├── sns.png

├── ec2.png

└── failover.png
```

---

# 💰 Cost Optimization

- Auto Scaling minimizes idle resources
- S3 Lifecycle policies reduce storage costs
- Infrastructure managed through Terraform
- On-demand failover reduces DR expenses

---

# 🔮 Future Improvements

- Amazon EKS
- Aurora Global Database
- AWS Backup
- Lambda Automation
- GitHub Actions CI/CD
- AWS Systems Manager
- AWS Application Recovery Controller
- Multi-Account Deployment

---

# 👨‍💻 Author

## Aman Dharpure

Cloud & DevOps Engineer

📧 Email

LinkedIn

GitHub

---

## ⭐ If you found this project useful, don't forget to Star this repository.
