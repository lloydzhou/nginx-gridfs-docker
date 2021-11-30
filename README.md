# nginx-gridfs

https://github.com/truezodic/nginx-gridfs

Nginx module for serving files from MongoDB's GridFS( support SCRAM-SHA-1)

# build
1. based on ubuntu:18.4
2. using multistage-build

# Usage

```
docker run [options] lloydzhou/nginx-gridfs

```

# test

## dependency
1. docker-compose

## start server
```
docker-compose up -d
```
## put file
```
docker-compose exec mongo mongofiles --authenticationDatabase=admin -uroot -ppassword --db=gridfs put /entrypoint.sh
```

## get file
```
curl http://localhost/gridfs/entrypoint.sh -vvv -o /dev/null
*   Trying 127.0.0.1:80...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to localhost (127.0.0.1) port 80 (#0)
> GET /gridfs/entrypoint.sh HTTP/1.1
> Host: localhost
> User-Agent: curl/7.80.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.19.9
< Date: Tue, 30 Nov 2021 10:11:46 GMT
< Content-Type: application/octet-stream
< Content-Length: 11314
< Connection: keep-alive
< 
{ [4096 bytes data]
100 11314  100 11314    0     0  5625k      0 --:--:-- --:--:-- --:--:-- 10.7M
```

