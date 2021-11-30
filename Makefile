build:
	docker build -t lloydzhou/nginx-gridfs -f Dockerfile . | tee /tmp/build.log

push:
	docker push lloydzhou/nginx-gridfs

test:
	docker run --rm -it -p 80:80 lloydzhou/nginx-gridfs



