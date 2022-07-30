# AWS Cloudfront

It is a content delivery network (CDN). It improves read performance, content is cached at the edge. AWS provides DDOS protection, integration

### CloudFront -Origin
- S3 bucket
 * For distribution of files and caching them at the edge
 * Enhanced security with CloudFront Origin Access Identity
 * CloudFront can be used as an ingress(to upload files to S3)
- Custom Origin (HTTP)
  * Application Load Balancer
  * EC2 instance
  * S3 website
### Hands on 

1. Create S3 bucket
2. Click on the created bucket above and upload the project files (HTML, image etc)
3. On AWS console, search for **CloudFront**
4. On the origin domain - Choose the required name
5. On the S3 bucket access, select **Yes use OAI (bucket can restrict access to only cloudFront)
6. On the Origin access identity **Create new OAI** and select it
7. On Bucket policy select **Yes, update the buckrt policy**
8. On the default root object, type the file name e.g **index.html**
9. Click on **Create distribution**

