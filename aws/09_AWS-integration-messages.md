# AWS Integration & Messaging

When deploying multiple applications, they will inevitably need to communicate with one another. There are two patterns of application communication
1. Synchronous communication(Application to application)
2. Asynchronous / Event based (application to queue to application)

<br>

Synchronous between applications can be problematic if there there are sudden spikes of traffic.

<br>

In this case, it's better to decouple your applications
- using SQS: queue model
- using SNS: pub/sub model
- using Kinesis: real-time streaming model. 
<br>
This services can scale independently from our application.

#### Amazon SQS(Simple queue service)
Amazon Simple Queue Service offers secure, durable, and available hosted queue that lets you integrate and decouple distributed software systems and components.

![](images/tutorials/sqs-asg.png)
![](images/tutorials/sqs-application-tier.png)
![](images/tutorials/sqs-security.png)

### SQS - Standard queue Hands on
1. Launch AWS management console and search for **SQS**
2. Click on create Queue
3. Select standard 
4. Name: DemoQueue
5. On access policy, select **Basic** for this demo
6. On encryption, select **Enabled** and choose the default **CMK**
7. Click on create
8. Test it by clicking on **Send and recieve messages**
9. click on **Send messages**

### SQS Queue Access Policy
![](images/tutorials/sqs-queue.png)
### SQS Queue Access Policy Hands on
1. Launch AWS management console and search for **SQS**
2. Click on create Queue
3. Select standard 
4. Name: DemoQueue
5. On access policy, select **Basic** for this demo
6. On encryption, select **Disabled** 
7. Click on create
8. Create S3 bucket to send notification to the SQS queue
- After creating S3 bucket, click on the bucket and navigate to the **properties** tab
- in **Event Notification**, click create **Event Notification**
- name: demoEvent
- Event Type: select all object
- Destination: Select SQS Queue
- Specify SQS queue: Select the queue created above **DemoQueue**
- Save changes
9. On the SQS queue, update the policy to enable S3 bucket to send message to SQS queue
```
{
    "Version": "2012-10-17",
    "Id": "example-ID",
    "Statement": [
        {
            "Sid": "example-statement-ID",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": [
                "SQS:SendMessage"
            ],
            "Resource": "SQS-queue-ARN",
            "Condition": {
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:*:*:awsexamplebucket1"
                },
                "StringEquals": {
                    "aws:SourceAccount": "bucket-owner-account-id"
                }
            }
        }
    ]
}
```

### SQS - Message Visibility Timeout
After a message is polled by a consumer, it becomes invisble to other consumer. The visibility period is 30 seconds. The consumer could call the ChangeMessageVisibility API to get more time.

### SQS Dead Letter Queues
To make a SQS queue a dead letter queue, enable dead letter queue
![](images/tutorials/sqs-dead-letter.png)

### SQS Delay Queues
To make a SQS queue a delay queue, set the queue **Delivery delay** to number more than 0. 0 is the default value.
![](images/tutorials/sqs-delay.png)
### SQS  - Long Polling
![](images/tutorials/sqs-long.png)

### SQS - Request-Response Systems
![](images/tutorials/sqs-rr.png)
### SQS - FIFO Queue 
In creating SQS fifo queue, the name must end with **.fifo**
![](images/tutorials/sqs-fifo.png)