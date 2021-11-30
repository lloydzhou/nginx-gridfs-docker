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

## default config
```
    server {
        listen 80 default_server;
        location ~ "^/gridfs/[0-9a-f]{24}$" {
            rewrite /gridfs/(.*) /$1 last;
        }
        location / {
            internal;
            gridfs gridfs field=_id type=objectid;
            mongo mongodb://root:password@mongo:27017/admin;
        }
        location /gridfs {
            gridfs gridfs field=filename type=string;
            mongo mongodb://root:password@mongo:27017/admin;
        }
    }
```

## get file by name
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
< Date: Tue, 30 Nov 2021 11:34:23 GMT
< Content-Type: application/octet-stream
< Content-Length: 11314
< Connection: keep-alive
< 
{ [4096 bytes data]
100 11314  100 11314    0     0  5674k      0 --:--:-- --:--:-- --:--:-- 10.7M
```

## get file by id
```
curl http://localhost/gridfs/61a60624833b6500b140e6a2 -vvv -o /dev/null
*   Trying 127.0.0.1:80...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to localhost (127.0.0.1) port 80 (#0)
> GET /gridfs/61a60624833b6500b140e6a2 HTTP/1.1
> Host: localhost
> User-Agent: curl/7.80.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.19.9
< Date: Tue, 30 Nov 2021 11:32:05 GMT
< Content-Type: application/octet-stream
< Content-Length: 11314
< Connection: keep-alive
< 
{ [8192 bytes data]
100 11314  100 11314    0     0  6172k      0 --:--:-- --:--:-- --:--:-- 10.7M
```

