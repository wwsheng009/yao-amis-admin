#docker build --build-arg ARCH=amd64 --build-arg VERSION=0.10.5 --tag yao-amis-admin-dev .
#docker run -d --restart unless-stopped --name yao-amis-admin-dev -p 5099:5099 yao-amis-admin-dev

ARG ARCH
FROM wwsheng009/yao-${ARCH}:latest

ARG ARCH
ARG VERSION
RUN mkdir -p /data/app
WORKDIR /data/app


RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
# RUN mkdir -p /data/app && curl -fsSL "https://github.com/wwsheng009/yao-amis-admin/releases/download/yao-amis-admin-${VERSION}/yao-amis-admin-${VERSION}.zip" > /data/app/latest.zip && \
#     unzip /data/app/latest.zip && rm /data/app/latest.zip && \
#     rm -rf /data/app/.git && \
#     chown -R yao:yao /data/app && \
#     chmod +x /data/app/init.sh && \
#     chmod +x /usr/local/bin/yao && \
#     cp /data/app/app.sample.yao /data/app/app.yao && \
#     mkdir -p /data/app/plugins && \
#     mkdir -p /data/app/db


ADD . /data/app
RUN rm -rf /data/app/.git && \
    rm -rf /data/app/.env* && \
    rm -rf /data/app/Dockerfile* && \
    rm -rf /data/app/node_modules && \
    chown -R yao:yao /data/app && \
    chmod +x /data/app/init.sh && \
    chmod +x /usr/local/bin/yao && \
    mkdir -p /data/app/plugins && \
    mkdir -p /data/app/db && \
    cp /data/app/app.sample.yao /data/app/app.yao


RUN apk add --no-cache nodejs npm

WORKDIR /data/app
RUN sh download_jssdk.sh
RUN sh download_plugin.sh ${ARCH}
RUN npm i yarn -g
RUN yarn install --production

USER root
VOLUME [ "/data/app" ]
WORKDIR /data/app


EXPOSE 5099
CMD ["sh", "init.sh"]