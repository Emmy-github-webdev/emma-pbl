# AWARE Liveness Container -- Hosting & Deployment Guide

## Overview

This document defines a repeatable, scalable AWS hosting model for deploying the Aware Knomi Face Liveness container using vendor-provided Docker images.

This is an investigation-phase architecture to:

- Validate feasibility
- Define baseline infrastructure
- Identify risks and unknowns before production investment

------------------------------------------------------------------------
## 1. Architecture (AWS)

### Core AWS Components

| Layer         | Service               | Purpose                  |
| ------------- | --------------------- | ------------------------ |
| Ingress       | ALB or API Gateway    | TLS termination, routing |
| Compute       | ECS (Fargate or EC2)  | Run container            |
| Registry      | ECR                   | Store Aware image        |
| Secrets       | AWS Secrets Manager   | License key              |
| Networking    | VPC (private subnets) | Secure runtime           |
| Observability | CloudWatch            | Logs + metrics           |

### Deployment Model Recommendation

#### Preferred: ECS Fargate

Why:

- No infrastructure management
- Fastest path to validation
- Works with vendor container

#### Alternative: EKS (Phase 2+)

Use if:

You already run Kubernetes
Need advanced scaling or multi-service orchestration
------------------------------------------------------------------------
## 2. Image Sourcing Strategy (ECR)

### Vendor Constraint

Aware distributes images as:
- .tar.gz (offline artifact)

### Standardized Ingestion Flow
_Step 1_ — Load Image
```
docker load --input aware-knomifaceliveness-docker-centos8.tar.gz
```
_Step 2_ — Tag for ECR

```
docker tag knomifaceliveness_tagname:latest \
<account>.dkr.ecr.<region>.amazonaws.com/aware/knomi-liveness:latest
```
_Step 3_ — Push to ECR
```
docker push <account>.dkr.ecr.<region>.amazonaws.com/aware/knomi-liveness:latest
```
------------------------------------------------------------------------
## 3. Compute & Resource Specification

### Baseline Sizing (Validated Assumption)

| Tier     | CPU    | Memory | Use Case         |
| -------- | ------ | ------ | ---------------- |
| Minimum  | 1 vCPU | 2 GB   | Dev/testing      |
| Baseline | 2 vCPU | 4 GB   | Stable workload  |
| Scaled   | 4 vCPU | 8 GB   | High concurrency |

### Workload Characteristics
- CPU-bound (computer vision processing)
- Stateless REST API
- Horizontal scaling preferred
- No persistent storage required

### Scaling Strategy

| Metric              | Trigger   |
| ------------------- | --------- |
| CPU > 70%           | Scale out |
| Request latency     | Scale out |
| Request queue depth | Scale out |

------------------------------------------------------------------------
## 4. Configuration & Secrets

### Required Configuration

| Type   | Key                                | Description     |
| ------ | ---------------------------------- | --------------- |
| Secret | `AWARE_LICENSE_KEY`                | Required to run |
| Env    | `PORT=8086` - To be decide         | Service port    |
| Env    | `LOG_LEVEL`                        | Logging         |

### Licensing Models (Critical Unknown)

Possible patterns:

- License file mounted into container
- Environment variable license key
- External license server

### AWS Implementation

| Component       | Usage           |
| --------------- | --------------- |
| Secrets Manager | Store license   |
| IAM             | Restrict access |
| Task Definition | Inject env vars |

------------------------------------------------------------------------
## 5. Deployment Model

### ECS Task Definition (Conceptual)

```
CPU: 2048
Memory: 4096

Container:
  Image: <ECR repo>
  Port: 8086
  Environment:
    - AWARE_LICENSE_KEY
    - PORT=8086
```

### Service Setup

- ALB → Target Group → ECS Service
- Health check:

```
/faceliveness/version
```

### Validation

```
curl http://<alb-endpoint>/faceliveness/version
```
------------------------------------------------------------------------
## 6. Security Architecture

### Required Controls

| Area    | Control               |
| ------- | --------------------- |
| Network | Private subnets       |
| Ingress | ALB with HTTPS        |
| Secrets | Secrets Manager       |
| IAM     | Least privilege roles |

------------------------------------------------------------------------
## 7. Gap Analysis

### Critical Risks

1. _Licensing Uncertainty_
- Unknown activation model
- Potential runtime dependency

2. _Vendor Distribution Model_
- Manual tarball delivery
- No version automation

3. _No Built-in Security_
- No auth
- No TLS

4. _Operational Risks_
- No healthcheck endpoint standard
- Logging format unclear
- No metrics exposed

5. _Scaling Risks_
- Unknown max concurrency
- No official performance benchmarks

6. _Platform Gaps_
- No IaC from vendor
- No Helm charts / ECS templates
------------------------------------------------------------------------
## Final Recommendation

Proceed with:
- ECS-based deployment
- Internal ECR image management
- Secrets Manager for licensing
- ALB ingress with HTTPS
------------------------------------------------------------------------