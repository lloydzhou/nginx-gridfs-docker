ARG IMAGE_TAG="18.04"

FROM ubuntu:${IMAGE_TAG} as builder

ARG NGINX_VERSION="1.19.9"
ARG COMMIT_HASH="e15b5cf"

RUN apt update && apt install -y git wget gcc make libmongoc-dev libpcre3-dev  libssl-dev zlib1g-dev
RUN git clone https://github.com/truezodic/nginx-gridfs
RUN  cd nginx-gridfs && git checkout ${COMMIT_HASH} \
  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O nginx.tar.gz \
  && tar -xf nginx.tar.gz && cd nginx-${NGINX_VERSION}\
  && ./configure --add-module=../nginx-gridfs/ \
  && make install

FROM ubuntu:${IMAGE_TAG}

RUN apt update && apt install -y libmongoc-1.0-0 libpcre3 libssl1.1 zlib1g
COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
RUN ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx \
  && ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
  && ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

