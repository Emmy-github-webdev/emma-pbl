Write the below command in script.sh

```
cat script.sh
#!/usr/bin/env bash
docker run -di -v /home/ubuntu/835964-docker-immutables-fixing:/mnt --name my-container busybox:latest
docker exec my-container rm /mnt/my-file.txt
```