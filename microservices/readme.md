# Microservices

## Monolithic vs. Microservices Architecture
With monolithic architectures, all processes are tightly coupled and run as a single service. This means that if one process of the application experiences a spike in demand, the entire architecture must be scaled. Adding or improving a monolithic application’s features becomes more complex as the code base grows. This complexity limits experimentation and makes it difficult to implement new ideas. Monolithic architectures add risk for application availability because many dependent and tightly coupled processes increase the impact of a single process failure.

<br>
With a microservices architecture, an application is built as independent components that run each application process as a service. These services communicate via a well-defined interface using lightweight APIs. Services are built for business capabilities and each service performs a single function. Because they are independently run, each service can be updated, deployed, and scaled to meet demand for specific functions of an application.
<br>

_Monolith_                            _Microservices_
|--------------------|                .....................
|  ..............    |                .    Users          .
|  .   Users     .   |                .....................
|  ..............    |                Users Service
|                    |                .....................
|   ..............   |   ----->       .    Threads        .
|   .  Threads   .   |                .....................
|   ..............   |                 Threads Service
|                    |                .....................
|   ................ |                .   Posts           .
|   .  Posts       . |                .....................
|   ................ |                  Posts Service
|--------------------|
Node.js API Service

### Characteristics of Microservices
1. _Autonomous:_ Each component service in a microservices architecture can be developed, deployed, operated, and scaled without affecting the functioning of other services.
2. _Specialized:_ Each service is designed for a set of capabilities and focuses on solving a specific problem. If developers contribute more code to a service over time and the service becomes complex, it can be broken into smaller services.

### Benefits/Advantages of Microservices
1. _Flexible scaling:_ Microservices allow each service to be independently scaled to meet demand for the application feature it supports.
2. _Easy deployment:_ Microservices enable continuous integration and continuous delivery, making it easy to try out new ideas and to roll back if something doesn’t work.
3. _technological Freedom:_ approach. Teams have the freedom to choose the best tool to solve their specific problems. As a consequence, teams building microservices can choose the best tool for each job.
4. _Reusable Code:_ Dividing software into small, well-defined modules enables teams to use functions for multiple purposes. A service written for a certain function can be used as a building block for another feature. This allows an application to bootstrap off itself, as developers can create new capabilities without writing code from scratch.
5. _Resilience:_ Service independence increases an application’s resistance to failure. In a monolithic architecture, if a single component fails, it can cause the entire application to fail. With microservices, applications handle total service failure by degrading functionality and not crashing the entire application.

### Disadvantages of Microservices

1. _Increased Complexity:_ Managing multiple microservices increases overall system complexity, as each service must be developed, deployed, and maintained independently. Coordinating communication and data consistency across services can be challenging.
2. _Distributed System Overheads:_ Microservices introduce network communication between services, which adds overhead compared to in-process communication in monolithic systems. This can lead to latency and performance issues.
3. _Data Management Challenges:_ Each microservice typically manages its own data, which can lead to difficulties in maintaining data consistency and implementing distributed transactions.
4. _Increased Deployment and Operational Overhead:_ Deploying and managing numerous services requires robust infrastructure and tooling. Continuous integration and deployment processes become more complicated, requiring sophisticated monitoring and management systems.
5. _Testing Complexity:_ Testing microservices can be more complicated than testing a monolithic application, as it involves ensuring that each service functions correctly both in isolation and in interaction with other services.