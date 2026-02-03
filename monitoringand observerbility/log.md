# Executive Summary (One Page)

This document defines the recommended strategy, architecture, and implementation approach for application logging, metrics, and alerting across all services deployed to TAWS (client AWS environment). The objective is to provide consistent observability, security visibility, and compliance-ready auditability while balancing cost, operational simplicity, and scalability.

The strategy adopts AWS-native services wherever possible, using CloudWatch for real-time observability, S3 for durable and cost-effective log retention, and centralized cross-account aggregation for security and audit workloads. Logging and monitoring capabilities are enabled by default through Infrastructure as Code (IaC) to ensure consistency across environments.

Key outcomes:
- End-to-end visibility across application, API, infrastructure, and network layers
- Centralized, secure, and compliant log storage
- Clear separation between operational monitoring and audit logging
- Environment-aware configurations to control cost and noise
- Reusable Terraform modules integrated into TAWS scaffolding

---

# 1. Introduction

## Purpose
Define a comprehensive logging, metrics, and alerting strategy for TAWS-hosted workloads that supports:
- Operational monitoring
- Security investigations
- Compliance and audit requirements

## Scope
- Application and API logging
- Infrastructure and network telemetry
- Security and audit logging
- Metrics and alerting
- Integration into TAWS via IaC

## Out of Scope
- Third-party SIEM customization beyond log delivery
- Application-level logging library implementation details

---

# 2. Design Principles

- AWS-native first
- Centralized logging, decentralized consumption
- Metrics for alerting, logs for investigation
- Environment-aware retention and verbosity
- Secure-by-default with least privilege access

---

# 3. Logging Sources

## Application & Service Logs
- ECS / EKS / Lambda application logs
- API Gateway and ALB access logs
- Structured JSON logging standard

## Infrastructure & Network Logs
- CloudTrail (all regions, org-wide)
- AWS Config
- VPC Flow Logs
- Load Balancer access logs
- WAF logs (where applicable)

## Security Logs
- GuardDuty
- Security Hub
- IAM access and role assumption logs

---

# 4. Logging Architecture

## High-Level Flow

```
Workloads / AWS Services
        |
        v
CloudWatch Logs (Hot)
        |
        v
Firehose / Subscription Filters
        |
        v
Central S3 Buckets (Warm / Cold)
        |
        +--> Athena / OpenSearch (Analysis)
```

## Storage Strategy

| Tier | Service | Purpose | Retention |
|----|----|----|----|
| Hot | CloudWatch Logs | Real-time troubleshooting | 14–90 days |
| Warm | S3 Standard / IA | Investigations | 90–180 days |
| Cold | S3 Glacier | Compliance | 1–7 years |

## Security
- KMS encryption (at rest)
- TLS in transit
- Separate security logging account
- S3 Object Lock for audit logs

---

# 5. Metrics Strategy

## Native Metrics
- ALB latency, 4xx/5xx
- Lambda duration and errors
- ECS task health
- Database performance

## Custom Metrics
- Business KPIs
- Error rate per API
- Queue backlog

---

# 6. Alerting & Monitoring

## Alert Categories
- Availability
- Performance
- Error rates
- Security events
- Cost anomalies

## Tooling
- CloudWatch Alarms
- EventBridge rules
- SNS integrations (PagerDuty / Slack)

## Alert Fatigue Controls
- Severity-based thresholds
- Aggregation windows
- Environment-specific tuning

---

# 7. Access Control & Retention

## Access
- IAM role-based access
- Read-only access for developers
- Security team ownership of audit logs

## Retention Matrix

| Log Type | Test | Production |
|----|----|----|
| Application | 14 days | 90 days |
| VPC Flow Logs | 7 days | 180 days |
| CloudTrail | 90 days | 1–7 years |
| Security Logs | 180 days | Compliance-based |

---

# 8. Logging Decision Matrix

| Capability | CloudWatch | S3 | OpenSearch |
|----|----|----|----|
| Real-time alerts | ✔ | ✖ | ✔ |
| Long-term retention | ✖ | ✔ | ✖ |
| Cost efficiency | Medium | High | Low |
| Full-text search | Limited | ✖ | ✔ |
| Compliance storage | ✖ | ✔ | ✖ |

---

# 9. IaC Integration (Terraform Examples)

## CloudWatch Log Group

```hcl
resource "aws_cloudwatch_log_group" "app" {
  name              = "/taws/${var.env}/${var.service}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn
}
```

## CloudWatch Alarm

```hcl
resource "aws_cloudwatch_metric_alarm" "high_5xx" {
  alarm_name          = "${var.service}-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_topic_arn]
}
```

## VPC Flow Logs to S3

```hcl
resource "aws_flow_log" "vpc" {
  vpc_id          = var.vpc_id
  traffic_type    = "ALL"
  log_destination = aws_s3_bucket.flow_logs.arn
  log_destination_type = "s3"
}
```

---

# 10. Operations & Runbook

- Verify log ingestion after deployments
- Monitor ingestion cost trends
- Review alarm effectiveness quarterly
- Test audit log immutability annually

---

# 11. Open Items

- Final compliance retention confirmation
- SIEM integration validation
- Cost modeling for peak workloads