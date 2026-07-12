# AWS Multi-Region Disaster Recovery with Terraform

A production-style disaster recovery architecture deployed across two AWS Regions using Terraform, Amazon EC2 Auto Scaling, Application Load Balancers, PostgreSQL RDS cross-Region replication, CloudWatch, SNS, EventBridge, and AWS Lambda.

## Architecture

### Primary Region — us-east-1

- Custom VPC
- Two public subnets
- Two private subnets
- Application Load Balancer
- Auto Scaling Group
- Amazon EC2 application server
- PostgreSQL RDS primary database
- CloudWatch alarms
- SNS email alerts

### Disaster Recovery Region — us-west-2

- Independent custom VPC
- Two public subnets
- Two private subnets
- Application Load Balancer
- Auto Scaling Group
- Amazon EC2 standby application server
- PostgreSQL cross-Region read replica
- KMS encryption
- Lambda failover function

## Automated Failover Workflow

1. CloudWatch monitors the Primary Auto Scaling Group.
2. The alarm enters the `ALARM` state when no Primary instances are in service.
3. EventBridge detects the alarm state change.
4. EventBridge invokes the failover orchestrator Lambda.
5. The Lambda prepares to:
   - Scale the DR Auto Scaling Group.
   - Promote the PostgreSQL read replica.
6. The current implementation runs with `DRY_RUN=true` for safe testing.

## AWS Services Used

- Amazon VPC
- Amazon EC2
- EC2 Auto Scaling
- Application Load Balancer
- Amazon RDS for PostgreSQL
- AWS KMS
- Amazon CloudWatch
- Amazon SNS
- Amazon EventBridge
- AWS Lambda
- AWS IAM
- Amazon S3
- Terraform

## Recovery Objectives

- Target RTO: 10–15 minutes
- Target RPO: Less than 5 minutes
- Replication type: Asynchronous cross-Region RDS replication

## Project Screenshots

### Primary Infrastructure

![Primary](docs/screenshots/primary.png)

### Disaster Recovery Infrastructure

![DR](docs/screenshots/dr.png)

### CloudWatch Monitoring

![CloudWatch](docs/screenshots/cloudwatch.png)

### Lambda Failover

![Lambda](docs/screenshots/lambda.png)

### EventBridge Automation

![EventBridge](docs/screenshots/eventbridge.png)

## Terraform Structure

```text
AWS-Multi-Region-DR/
├── bootstrap/
├── environments/
│   ├── primary/
│   └── dr/
├── lambda/
│   └── failover/
├── modules/
│   ├── alb/
│   ├── compute/
│   ├── database/
│   ├── database-replica/
│   ├── eventbridge/
│   ├── failover-lambda/
│   ├── iam/
│   ├── monitoring/
│   ├── networking/
│   └── security/
└── docs/