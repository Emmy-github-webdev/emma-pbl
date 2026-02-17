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

## Application Logging Contract

All services must emit structured JSON logs with the following minimum
schema:

``` json
{
  "timestamp": "",
  "level": "INFO | WARN | ERROR",
  "service": "",
  "environment": "",
  "correlation_id": "",
  "workflow_id": "",
  "workflow_stage": "",
  "event_type": "",
  "latency_ms": 0,
  "status_code": 200,
  "error_code": "",
  "user_hash": "",
  "tenant_id": "",
  "metadata": {}
}
```

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

## Matrix

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

## Verify log ingestion after deployments

Operational logging and monitoring controls are only effective if continuously validated. The following procedures ensure observability remains reliable, cost-effective, and audit-ready over time.

Objective 

Ensure no deployment results in loss of observability.

When:

- After every production deployment
- After infrastructure changes (IAM, KMS, networking, Firehose, log subscriptions)
- After onboarding new services

## What to Verify

Application Layer:

- Logs are appearing in the correct CloudWatch Log Group
- Log format conforms to the structured JSON contract
- Required fields (correlation_id, service, environment, level) are present
- No PII fields are being logged
- Error-level logs are correctly captured

Infrastructure Layer:

- NLB/API logs are delivered to S3
- VPC Flow Logs (if enabled) are delivered successfully
- CloudTrail logging is active in all regions

Security Layer:

- GuardDuty findings are flowing to Security account
- CloudTrail events visible in centralized bucket
- Object Lock enabled for audit buckets (production)

## Validation Methods

- Query CloudWatch Logs Insights for recent events
- Confirm log group retention settings
- Verify subscription filters are active
- Validate S3 object delivery timestamps
- Trigger controlled test error to confirm alarm path

## Ownership

- Dev team: application logs
- Platform team: infrastructure logs
- Security team: audit log ingestion

## Monitor Ingestion Cost Trends

Objective

Prevent observability tooling from becoming a runaway cost driver.

## Monthly Cost Review

Track:

- CloudWatch Logs ingestion (GB/day)
- CloudWatch retention storage costs
- S3 storage growth rate
- Firehose data processing charges
- OpenSearch indexing/storage (if used)

## Key Indicators of Cost Drift

- Sudden increase in INFO logs
- Debug logging enabled in production
- High-volume success events without sampling
- Excessive VPC Flow Logs in non-production
- Unexpected OpenSearch indexing spikes

## Controls

- Enforce environment-based log level configuration
- Sample high-frequency success logs
- Keep ERROR logs unsampled
- Automatically transition S3 logs to Glacier after defined period
- Review top log-producing services quarterly

## Reporting

Create a lightweight monthly report including:

- Total log ingestion (GB)
- Cost by service/environment
- Top 5 log producers
- Recommended tuning actions

## Review Alarm Effectiveness Quarterly

Objective 

Ensure alerts remain actionable, meaningful, and aligned to business risk.

Over time, alerts degrade in value due to:

- Architecture changes
- Traffic growth
- Workflow changes
- Threshold drift

## Quarterly Review Checklist

- Noise Evaluation
- Number of alerts triggered
- % of alerts that required action
- Alerts acknowledged but no remediation needed
- Repeated flapping alarms

## Test Audit Log Immutability Annually

Objective: Validate that compliance controls are enforceable and tamper-resistant.

Audit logs are only compliant if:
- They cannot be altered
- They cannot be deleted prematurely
- Retention policies are enforced

## Ownership

- Security team primary
- Platform team support
- Compliance oversight
---

# 11. Application-Specific Logging & PII Strategy

## Logging Without Storing PII

For this workload, we should explicitly separate:
- Identifiers used for correlation
- PII fields
- Business context metadata

## Approved Correlation Identifiers (Safe to Log)

We should log:
- request_id (API Gateway or generated UUID)
- correlation_id (propagated across services)
- workflow_id
- hashed_user_id
- tenant_id
- device_id_hash
- session_id
- order_id / transaction_id (non-PII surrogate keys)

Never Log:
- Name
- Email
- Phone number
- Address
- SSN
- Payment details
- Access tokens
- Raw JWTs
- Full request bodies (unless explicitly redacted)

## Hashed Identifier Strategy

To “key off values in the ID” without logging PII:

Pattern

Instead of logging:
{
  "email": "user@email.com"
}

Log:
{
  "user_hash": "sha256(email + system_salt)"
}

## Implementation Rules

- Use SHA-256
- Include environment-specific salt
- Hash before logging (application layer, not CloudWatch)
- Never log the pre-hash value
- Maintain mapping only in transactional DB (not logs)

This allows:
- Security investigations
- Abuse pattern detection
- Cross-service correlation
- Fraud detection
Without exposing personal data.

## Structured Logging Contract

All services must emit structured JSON logs with this minimum schema:
```json
{
  "timestamp": "",
  "level": "INFO | WARN | ERROR",
  "service": "",
  "environment": "",
  "correlation_id": "",
  "workflow_stage": "",
  "event_type": "",
  "latency_ms": 0,
  "status_code": 200,
  "error_code": "",
  "user_hash": "",
  "metadata": {}
}
```
This enables:
- Metric filters
- Athena queries
- OpenSearch dashboards
- SIEM integration

---
# 12. Workflow-Specific Alerts

Instead of generic 5xx alerts only, we should define alerts tied to business workflow states.

Below are proposed alerts aligned to a typical request-driven workflow:

Availability Alerts:

| Alert                   | Trigger         | Threshold        | Environment |
| ----------------------- | --------------- | ---------------- | ----------- |
| API 5xx Spike           | ALB 5xx         | > 2% over 5 mins | All         |
| API Latency             | P95 > threshold | > 2s for 5 mins  | Prod        |
| Service Unhealthy Tasks | ECS health      | < desired count  | All         |

## Workflow Integrity Alerts
These are more important than infra alerts.

_Stuck Workflow Detection_

Trigger:
- Workflow stage not advanced within expected SLA
Example:
- workflow_stage = PAYMENT_PENDING
- No transition after 10 minutes
Implementation:
- Emit metric per stage
- CloudWatch metric math for aging
- Or EventBridge rule for timeout

_Failure Rate by Stage_

Trigger:
- event_type = WORKFLOW_FAILED
- 3% over 10 minutes

Why:
Detect logic bugs before total outage.

_Repeated Attempts per User Hash_

Trigger:
- X failed attempts per user_hash in 10 minutes
Purpose:
- Abuse detection
- Fraud detection
- Credential stuffing

No PII required.

_Queue Backlog Alert_

If using SQS:
- Visible messages > threshold
- Age of oldest message > threshold

This directly correlates to customer-facing delay.

## Security-Specific Alerts

From:
- Amazon GuardDuty
- AWS Security Hub
- AWS CloudTrail

Proposed alerts:

| Event                   | Action              |
| ----------------------- | ------------------- |
| Root account usage      | Immediate PagerDuty |
| IAM policy change       | Slack + ticket      |
| KMS key disabled        | PagerDuty           |
| CloudTrail stopped      | Critical incident   |
| S3 Object Lock disabled | Critical incident   |

---

# 13. Mobile Logging Strategy

Mobile logging is currently missing and should be explicitly defined.
## Mobile Log Categories
- Client-side errors (crashes, exceptions)
- Network failures
- Latency metrics
- Authentication failures
- Version metadata
## Recommended Flow
Mobile App
→ HTTPS
→ Ingestion API
→ CloudWatch Logs
→ S3 (centralized)

Do NOT allow:
- Direct mobile-to-S3
- Direct mobile-to-CloudWatch

## Mobile Log Structure
```json
{
  "app_version": "",
  "os_version": "",
  "device_model": "",
  "network_type": "",
  "correlation_id": "",
  "user_hash": "",
  "event_type": "",
  "error_code": ""
}

```
## Mobile-Specific Alerts
| Alert                        | Trigger                   |
| ---------------------------- | ------------------------- |
| Crash rate spike             | > 2% sessions             |
| Version-specific error spike | Error rate by app_version |
| Auth failure spike           | > threshold per 5 min     |
| API latency by mobile        | P95 > SLA                 |

This helps detect:
- Bad app releases
- Backend compatibility issues
- Device-specific bugs

---
# 14. Environment-Specific Behavior
## Test
Test:
- Lower retention
- Debug logging enabled
- No PagerDuty
- Relaxed thresholds
## Production
Production:
- Info level logging
- Strict thresholds
- PagerDuty enabled
- Compliance retention enforced
- Object Lock for audit logs

---
# 15. Cost Controls Specific to This Workload
## Cost explosion
To avoid cost explosion:
- Disable VPC Flow Logs in non-prod unless debugging
- Use sampling for high-volume success logs
- Keep ERROR logs unsampled
- Use CloudWatch metric filters instead of shipping everything to OpenSearch
- Tier S3 to Glacier after 90 days automatically

---

# 16. Open Items

## Items
- Final compliance retention confirmation
- SIEM integration validation
- Cost modeling for peak workloads