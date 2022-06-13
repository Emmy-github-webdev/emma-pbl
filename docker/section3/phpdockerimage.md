### Build an express.js image

1. Make PHP directory and change directory to it

```
mkdir php
cd php
code .
```
2. Create Dockerfile and index.php file 

```
touch Dockerfile
touch index.php
```

3. Add text to the index.php file

```
<html>
<?php echo "Hello world from a php container" ?>
</html>
```

4. Add text to the Dockerfile file

```
FROM php
COPY ./index.php ./
EXPOSE 80
CMD ["php", ""-s, "0.0.0.0:80"]
```

5. Build the container

```
docker build . -t emma/php
```

6. Run the container

```
docker run --name=php -p=3003:80 emma/php
```

7. Visite **localhost:3003** on the browser