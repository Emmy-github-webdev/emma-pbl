# Introduction to Monitoring and Observability

Monitoring and observability form the backbone of system reliability. This guide explains what to monitor, why it matters, and how modern observability practices help teams understand system behavior end-to-end.

## Why Monitoring Matters

- Detect issues before users notice
- Ensure system uptime and reliability
- Improve performance and user experience
- Measure and improve business outcomes
## Core Concepts
- Metrics
- Time series
- Exporter
- Pull model

## The Layers of Monitoring
_Layers 1 - 4_
1. Browser/Frontend Monitoring: Real user monitoring tp measure true user experience across geographies.
_Key Metrics_
- Page load time (TTFB, FCP)
- Core web vitals(LCP, FID, CLS)
- Javascript Errors
- User navigation and clicks
_Tools:_ Datadog RUM, New Relic Browser, Sentry, Pingdom RUM
_Example:_ Track checkout page load time for users in India.

2. Application Performance Monitoring (APM): Backend code and API experience across geographies.
_Key Metrics_
- Response time
- Throughtput
- Error rate
- Database query performance
- External API latency
- End-to-end tracing
_Tools:_ New Relic, Datadog APM, AppDynamics, Dynatrace, Elastic APM
_Example:_ Trace API latency from NGINX → Java → MySQL.
3. Infrastructure Monitoring: Servers, containers, and resources, monitored for health and capacity.
_Key Metrics_
- CPU, Memory, Disk, Network usage
- Node Health, uptime
- Pod/Container status (Kubernetes)
_Tools:_ Prometheus + Grafana, CloudWatch, Datadog Infra, Zabbix, Nagios
_Example:_ Trigger alert when EC2 CPU > 90% for 5 minutes.
4. Synthentic Monitoring:
_Key Metrics_
- Availabilty checks
- Transaction flows
- API testing
_Tools:_ Pingdom, Checkly, Datadog Synthetics, CloudWatch Canaries
_Example:_ Simulate user login from Mumbai and London every 10 minutes.
_Layers 5 - 7_
5. Business / API Monitoring:
_Key Metrics_
- Signup per minutes
- Conversion rate
- Failed payment
- Daily active users
_Tools:_ Mixpanel, Amplitude, Google Analytics, Datadog custom metrics
_Example:_ Alert when checkout success rate < 95%.
6. Log Monitoring: 
_Key Metrics_
- Error Frenquency
- Request logs
- Authentication failures
_Tools:_ ELK Stack, Grafana Loki, Splunk, CloudWatch Logs
_Example:_ Detect spike in TimeoutException logs after deployment.
7. Security Monitoring:
_Key Metrics_
- Unauthorized access attempts
- IAM anomalies
- Intrusion detection events
_Tools:_ AWS GuardDuty, Datadog Security, Splunk Security, Wazuh

### Pillars of Observerbility
- Metrics
- Logs
- Traces
- Events  / Changes
_Tools:_ OpenTelemetry, Grafana Stack, Datadog, New Relic