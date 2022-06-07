# Simple Application - Voting application

![](voting-app.png)

_Note:_ Assume everything has been built and available on docker image

1. **Data Layer**

```
# Run Redis instance
docker run -d --name=redis redis

# Run postgress
docker run -d --name=db postgres:9.4
```

2. **Application Image**

```
docker run -d --name=vote -p 5000:80 voting-app
```

3. **Result wep App**

```
docker run -d --name=result -p 5001:80 result-app
```

4. **Worker**

```
docker run -d --name=worker worker
```

<br>

This this point, the application will not work yet becauses the containers are not linked together

#### Links 

The link is a command line option which can be  used to connect containers together.

**Note** - The voting app depends on the Redis, result app depends on the db, worker depends on both Redis and DB.

```
docker run -d --name=vote -p 5000:80  --link redis:redis voting-app

docker run -d --name=result -p 5001:80 --link db:db result-app

docker run -d --name=worker --link db:db --link redis:redis worker
```