# AWS

### Configuring Billing Alarm

- On the AWS Console, search for **Billing**
- Click on **Budget** under the **Billing**
- Click on **Create a Budget**
- Select **Cost Budget** and **Next**
- On setup your budget page
    * Budget name - **Monthly Budget**
    * Peroid - **Monthly**
    * Budget renewal type - **Recurring budget**
    * Set start month
    * Budgeting method - **Fixed**
    * Enter your budgeted amount($) - **Enter and amount**
    * Leave the rest as default and click next
- On configure alerts
    * Add an alert threshold
    * Set alert threshold - **Add threshold**
    * Email alert - **Enter an email for alert**
- Next
- Next
- Create

### [AWS Global Infrastructure](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)

- AWS Regions: Region is a physical location around the world we have cluster data centers. Example is us-east-1, eu-west-1. Factors that determins how to choose an AWS Region inclues:
    * Compliance with data governance and legal requirements.
    * Promiximity to intended customers reduces latency
    * Availability of services with a region since not all services are available for all region
    * Pricing: Pricing also varies from region to region
- AWS Availability Zones: AZ is one or more discrete data centers within redundant power, networking, and connectivity in an AWS region. Usually, each region has min of 3 , and max of 6 AZ.
- AWS Data Centers
- AWS Edge Locations / Points of presence

### I AM
- I AM  = Identity and access management

> Create IAm account for security
- On the AWS console, search for **IAM**
