# AWS ElastiCache Overview

The same way RDS is to get managed Relational Databases, ElastiCache is to get managed Redis and Memcached. Caches are in-memory databases with really high performance, low latency. It makes application stateless.

<br>

Using ElastiCache involoves heavy application code changes.

#### ElastiCache Solution Architecture - DB Cache

- Application queries ElastiCache, if not available, get from RDS and store in the ElastiCache.

- Helps relieve load in RDS

- Cache must have aninvalidation strategy to make sure only the most current data is used in there.

![](images/tutorial/db-cache.png)

#### ElastiCache Solution Architecture - User Session Store

- User logs into any of the application
- The application writes the session data into ElasticCache
- The user hits another instance of our application
- The instance retrieves the data and the user is already logged in.

![](images/tutorial/user-session.png)

![](images/tutorial/redis-memcache.png)