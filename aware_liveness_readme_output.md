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
| VPC           | Existing VPC          | Secure runtime           |
| Private subnets    | existing private subnets | Secure runtime   |
| Public subnets    | existing public subnets | Internet facing   |
| Security group    | ECS SG | Allow traffic   |
| Routing    | Existing routing (NAT, IGW) | Traffic route         |
| Observability | CloudWatch            | Logs + metrics           |

### Deployment Model Recommendation

#### Preferred: ECS Fargate

Why:

- No infrastructure management
- Fastest path to validation
- Works with vendor container

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

## 6. Security Architecture

### VPC Reuse Strategy

#### Approach

We do NOT create a new VPC. Instead:
Reuse:
Existing VPC
Existing private subnets
Existing public subnets
Existing routing (NAT, IGW)

#### Required Inputs

| Parameter            | Description           |
| -------------------- | --------------------- |
| `vpc_id`             | Existing VPC ID       |
| `private_subnet_ids` | Subnets for ECS tasks |
| `public_subnet_ids`  | Subnets for ALB       |

#### Placement Model

```
Public Subnet:
  ALB (Internet-facing)

Private Subnet:
  ECS Tasks (Knomi container)
```

#### ALB Security Group

_Inbound_

| Port | Source    | Purpose       |
| ---- | --------- | ------------- |
| 443  | 0.0.0.0/0 | HTTPS traffic |


_Outbound_
| Port | Destination        |
| ---- | ------------------ |
| 8080 | ECS Security Group |

#### ECS (Knomi) Security Group

_Inbound_

| Port | Source             | Purpose           |
| ---- | ------------------ | ----------------- |
| 8080 | ALB Security Group | Allow API traffic |


_Outbound_

| Port | Destination | Purpose                  |
| ---- | ----------- | ------------------------ |
| 443  | 0.0.0.0/0   | License server / updates |
| ALL  | VPC CIDR    | Internal communication   |

### Key Constraint

The Knomi container:
- Does NOT provide TLS
- Does NOT manage certificates

TLS must be handled externally

### Recommended Approach: AWS ACM + ALB

_Flow_

Client (HTTPS)
   ↓
ALB (TLS termination via ACM)
   ↓
HTTP (8086)
   ↓
Knomi container

### End-to-End Traffic Flow

User → HTTPS (443)
   ↓
ALB (ACM Certificate)
   ↓
Target Group (port 8086)
   ↓
ECS Task (Knomi container)
   ↓
/faceliveness/version

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
    - PORT=8080
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
## 6. Gap Analysis

This section outlines key risks identified during investigation, along with their impact and recommended mitigation approach.

1. _Licensing Uncertainty_

The Aware container requires a license, but the activation mechanism is not fully defined:
- Could be file-based, environment variable, or external license server
- No clarity on renewal, expiry, or failure behavior

2. _Vendor Distribution Model_
The container is distributed as a manual .tar.gz artifact:
- No Docker registry
- No version tagging or pull mechanism

3. _No Built-in Security_
The container exposes a REST API but:
- No authentication mechanism
- No TLS/HTTPS support

4. _Operational Risks_
Limited operational visibility:
- No standard healthcheck endpoint
- Logging format not documented
- No native metrics exposed

5. _Scaling Risks_
No official guidance on:
- Maximum concurrency
- Throughput limits
- Resource consumption patterns

------------------------------------------------------------------------
## Final Recommendation

Proceed with:
- ECS-based deployment
- Internal ECR image management
- Secrets Manager for licensing
- ALB ingress with HTTPS
------------------------------------------------------------------------