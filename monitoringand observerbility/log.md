TAWS Logging, Metrics & Alerting — Design Document

Summary
- Goal: Provide an AWS-native, centralized logging, metrics, and alerting strategy for TAWS that supports operations, security investigations, and compliance while balancing cost and simplicity.
- Core approach: Short-term operational data in CloudWatch; centralized long-term archival in a logging account S3 bucket via Kinesis Firehose / direct delivery; cross-account roles and KMS for encryption; CloudWatch Metrics/Alarms + ADOT/X-Ray for tracing.

Logging Sources (what to enable)
- Management / Audit: CloudTrail (org-wide, multi-region, management + data events) -> central S3 + CloudWatch Logs. Enable CloudTrail Insights where helpful.
- API / App: Structured application logs -> CloudWatch Logs. Instrument with OpenTelemetry (ADOT) to send traces to X-Ray/CloudWatch.
- Compute: EC2/ECS/EKS/Lambda logs -> CloudWatch Logs. Use Fluent Bit for containers to forward structured logs to Firehose or CloudWatch.
- Network: VPC Flow Logs (VPC-level or subnet/ENI) -> CloudWatch or Firehose -> central S3. Transit Gateway flow logs if TGW used.
- Load Balancers: ALB/NLB access logs -> S3 (enable access_logs).
- Database: RDS audit & slow query logs -> CloudWatch or S3 depending on DB engine.
- Security: AWS Network Firewall logs, WAF logs (via Firehose), GuardDuty findings (EventBridge/SNS).
- Platform: AWS Config, VPC DNS logs, and optional VPC Traffic Mirroring for deep packet capture (use sparingly).

Storage, Retention & Security
- Central logging account: store long-term logs in a dedicated `ta-ws-logging` account S3 bucket.
- Ingestion: CloudWatch Log Groups for operations; use Firehose to deliver to central S3 with compression (GZIP) and optional conversion to Parquet.
- Encryption: Use `SSE-KMS` with a CMK owned by the logging account; cross-account key grants where necessary.
- Retention: CloudWatch = short-term (operational window). Export to S3 for archival and compliance retention.
- Immutability & integrity: Use S3 Object Lock (Governance/Compliance) where required; enable CloudTrail log file validation.
- Cross-account delivery: grant minimal IAM roles for Firehose/ALB to write to central S3.

Retention Recommendations (baseline)
- Production CloudWatch Logs: 90 days, then export to S3.
- Production S3 archival: 7 years (or as required by compliance), lifecycle to Glacier/Deep Archive.
- Non-Prod: CloudWatch 14–30 days; no long-term archival unless required.
- CloudTrail: keep at least 1 year in S3; enable log validation.

Access Control & Governance
- Principle of least privilege for delivery roles. Central account owns KMS.
- Enforce encryption-at-rest and in-transit via org policy/SCP.
- Monitor access to logs via CloudTrail + S3 access logs; alert on suspicious access patterns.

Metrics & Alarms (baseline)
- Emit application business metrics as custom CloudWatch metrics (use ADOT).
- Recommended infra/app metrics & thresholds:
  - `CPUUtilization` (EC2/ECS host): >85% for 5m -> P2
  - `MemoryUtilization`: >85% for 5m -> P2
  - `HTTP 5XX rate` (ALB/API): >1% or >X/min -> P1/P2 (tune per app)
  - `P95 latency` (API): greater than SLO threshold for 5m -> P2
  - `LambdaErrors` & `Throttles`: sustained increase -> P2
  - `RDS ReplicaLag`: >60s -> P2
  - `GuardDuty Findings` severity HIGH -> P1
  - `CloudTrail Suspicious` (root sign-in, console login fail spikes) -> P1
- Notification: CloudWatch Alarm -> SNS -> PagerDuty/Slack/email. Use EventBridge for routing advanced workflows.

Observability & Tracing
- Use AWS X-Ray or ADOT to collect distributed traces. Correlate trace-id in logs.
- For containers, enable Container Insights for ECS/EKS selectively.

IAC Scaffolding (patterns & snippets)
- Provide small, reusable modules for: logging account (S3 + KMS), cross-account Firehose delivery, CloudTrail, VPC Flow Logs, CloudWatch Alarm templates.

Example: VPC Flow Log -> CloudWatch
```hcl
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/taws/${var.env}/vpc-flow/${var.vpc_id}"
  retention_in_days = var.retention_days
  kms_key_id        = var.kms_key_arn
}

resource "aws_flow_log" "vpc" {
  resource_type   = "VPC"
  resource_id     = var.vpc_id
  traffic_type    = "ALL"
  log_destination = aws_cloudwatch_log_group.vpc_flow.arn
  iam_role_arn    = var.flow_role_arn
}
```

Example: Firehose -> central S3
```hcl
resource "aws_kinesis_firehose_delivery_stream" "logs_to_s3" {
  name        = "taws-logs-${var.env}"
  destination = "s3"
  s3_configuration {
    role_arn           = var.firehose_role_arn
    bucket_arn         = var.logging_bucket_arn
    buffer_size        = 128
    compression_format = "GZIP"
    kms_key_arn        = var.kms_key_arn
    prefix             = "${var.account_id}/%Y/%m/%d/"
  }
}
```

Example: CloudTrail -> central S3
```hcl
resource "aws_cloudtrail" "org_trail" {
  name                          = "taws-org-trail"
  s3_bucket_name                = var.logging_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
```

Cost Considerations & Optimizations
- Big drivers: CloudWatch ingestion & retention, VPC Flow Logs volume, X-Ray traces.
- Optimizations: sample VPC Flow Logs in non-prod; use filters to reduce flow log volume; compress and convert logs to columnar formats in S3.
- Keep CloudWatch as operational window, use S3 for archival.

Integration & Deployment Pattern
- Per-account lightweight forwarders (CloudWatch Log Groups/Firehose) -> central logging account S3
- Central account owns CMK and archival lifecycle
- Enforce naming and tagging standards: `/taws/{env}/{account}/{service}/{component}` and tags `env`, `team`, `service`.

Acceptance Criteria Mapping
- Network telemetry: VPC Flow Logs, ALB/NLB access logs, Network Firewall/WAF logs, Transit Gateway flow logs where applicable.
- Storage & retention: CloudWatch short-term; central S3 long-term; KMS-protected; lifecycle to Glacier.
- Monitoring & alerting: CloudWatch Alarms + EventBridge + SNS; GuardDuty and CloudTrail triggers for security.
- Cost/operational balance: sampling in non-prod, shorter CloudWatch retention, compressed S3 archival.

Implementation Checklist
- Create `ta-ws-logging` account with S3 bucket & CMK
- Enable Organization CloudTrail -> central S3
- Deploy Firehose and cross-account roles for delivery
- Enable VPC Flow Logs and ALB access logs for prod VPCs
- Instrument apps with ADOT/X-Ray and structured logs
- Create baseline CloudWatch alarms + SNS topics
- Run 30-day pilot, tune retention and sampling

