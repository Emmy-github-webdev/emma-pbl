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