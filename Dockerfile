ARG IMAGE_TAG="18.04"


# builder-env
FROM ubuntu:${IMAGE_TAG} as builder-env
RUN apt update && apt install -y git wget gcc make libmongoc-dev libpcre3-dev  libssl-dev zlib1g-dev


# runtime-env
FROM ubuntu:${IMAGE_TAG} as runtime-env
RUN apt update && apt install -y libmongoc-1.0-0 libpcre3 libssl1.1 zlib1g


# builder
FROM builder-env as builder

ARG NGINX_VERSION="1.19.9"

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O nginx.tar.gz && tar -xf nginx.tar.gz

ARG COMMIT_HASH="9a4c110"

RUN git clone https://github.com/lloydzhou/nginx-gridfs-1 nginx-gridfs
# RUN  cd nginx-gridfs && git checkout ${COMMIT_HASH} \
RUN  cd nginx-${NGINX_VERSION} && ./configure --add-module=../nginx-gridfs/nginx-gridfs/ && make install


# image
FROM runtime-env

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
RUN ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx \
  && ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
  && ln -sf /dev/stderr /usr/local/nginx/logs/error.log

