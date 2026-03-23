# AWARE Liveness Container -- Hosting & Deployment Guide

## Overview

This document defines the baseline hosting, configuration, and
deployment requirements for the Aware Knomi Face Liveness Docker
container. It is intended for platform teams preparing AWS-based
environments.

------------------------------------------------------------------------

## 1. Image Sourcing (ECR Ingestion)

### Load Image

``` bash
docker load --input aware-knomifaceliveness-docker-centos8.tar.gz
```

### Tag for ECR

``` bash
docker tag knomifaceliveness_tagname:latest <account-id>.dkr.ecr.<region>.amazonaws.com/aware/knomi-liveness:latest
```

### Authenticate & Push

``` bash
aws ecr get-login-password --region <region> \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

docker push <account-id>.dkr.ecr.<region>.amazonaws.com/aware/knomi-liveness:latest
```

------------------------------------------------------------------------

## 2. Resource Specification

  Environment   CPU      Memory
  ------------- -------- --------
  Minimum       1 vCPU   2 GB
  Baseline      2 vCPU   4 GB
  Scaled        4 vCPU   8 GB

------------------------------------------------------------------------

## 3. Configuration

### Required Environment Variables

-   AWARE_LICENSE_KEY (or mounted license file)
-   PORT (default: 8086)
-   LOG_LEVEL (optional)

### Licensing Options

-   License file mount
-   Environment variable key
-   License server (if applicable)

------------------------------------------------------------------------

## 4. Dependencies

-   Port: 8086
-   Stateless service (no DB required)
-   Optional: license server

------------------------------------------------------------------------

## 5. Deployment Guide

### Run Container

``` bash
docker run -d \
  -p 8086:8086 \
  --name knomi-liveness \
  -e AWARE_LICENSE_KEY=<secret> \
  <ecr-repo>/aware/knomi-liveness:latest
```

### Health Check

``` bash
curl http://localhost:8086/faceliveness/version
```

------------------------------------------------------------------------

## 6. AWS Deployment

### ECS Recommended

-   CPU: 2048
-   Memory: 4096
-   Load balancer required

### EKS Alternative

-   Deployment + Service
-   HPA enabled

------------------------------------------------------------------------

## 7. Gap Analysis

### Critical

-   License mechanism unclear
-   No official resource benchmarks

### Operational

-   Logging strategy undefined
-   No built-in authentication
-   No TLS support

### Architectural

-   Scaling characteristics unknown
-   Concurrency limits undocumented

------------------------------------------------------------------------

## 8. Final Spec

-   Port: 8086
-   Stateless container
-   CPU baseline: 2 vCPU
-   Memory baseline: 4 GB
-   License required via secret

------------------------------------------------------------------------

## Recommendation

Start with ECS deployment, validate performance under load, and refine
scaling strategy.
