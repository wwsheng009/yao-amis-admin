#docker build --build-arg ARCH=amd64 --build-arg VERSION=0.10.5 --tag yao-amis-admin-dev .
#docker run -d --restart unless-stopped --name yao-amis-admin-dev -p 5099:5099 yao-amis-admin-dev
ARG ARCH=amd64
ARG VERSION=0.10.5
FROM alpine:latest AS builder
USER root

RUN mkdir -p /data/app
WORKDIR /data/app

RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao

ADD . /data/app
RUN rm -rf /data/app/.git && \
    rm -rf /data/app/.github && \
    rm -rf /data/app/Dockerfile* && \
    rm -rf /data/app/node_modules && \
    rm -rf /data/app/public/amis-editor && \
    rm -rf /data/app/public/soy-admin && \
    chmod +x /data/app/init.sh && \
    mkdir -p /data/app/plugins && \
    mkdir -p /data/app/db && \
    cp /data/app/.env.sqlite /data/app/.env && \
    cp /data/app/app.sample.yao /data/app/app.yao

WORKDIR /data/app

RUN apk add  --no-cache curl

RUN sh download_plugin.sh ${ARCH} && sh download_jssdk.sh

RUN apk add --no-cache nodejs npm
RUN npm i yarn -g
RUN yarn install --production
RUN chown -R yao:yao /data/app

FROM wwsheng009/yao-${ARCH}:latest
# for bun js plugins
RUN apk add --no-cache curl libstdc++ libgcc
RUN chmod +x /usr/local/bin/yao
RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
COPY --from=builder /data/app /data/app
USER root
VOLUME [ "/data/app" ]
WORKDIR /data/app

EXPOSE 5099
CMD ["sh", "init.sh"]