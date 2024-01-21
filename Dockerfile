#docker build --platform linux/amd64 --tag demo-project .
#docker run -d --restart unless-stopped --name demo-project -p 5099:5099 demo-project

ARG ARCH
FROM wwsheng009/yao-${ARCH}:latest

ARG ARCH
ARG VERSION
WORKDIR /data

#COPY yao /usr/local/bin/yao cp /data/docker.env /data/.env && \
#RUN apk add git
RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
RUN mkdir -p /data && curl -fsSL "https://github.com/wwsheng009/yao-amis-admin/releases/download/yao-amis-admin-${VERSION}/yao-amis-admin-${VERSION}.zip" > /data/latest.zip && \
    unzip /data/latest.zip && rm /data/latest.zip && \
    rm -rf /data/.git && \
    chown -R yao:yao /data && \
    chmod +x /data/init.sh && \
    chmod +x /usr/local/bin/yao && \
    cp /data/docker.env /data/.env && \
    cp /data/app.sample.yao /data/app.yao && \
    mkdir -p /data/db

RUN mkdir -p /data/public/amis-editor && \
    curl -fsSL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.0.0/amis-editor-1.0.0.zip" > /data/public/amis-editor/latest.zip && \
    unzip /data/public/amis-editor/latest.zip -d /data/public/amis-editor/ && \
    rm /data/public/amis-editor/latest.zip

RUN mkdir -p /data/public/soy-admin && \
    curl -fsSL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/0.10.4/soy-yao-admin-0.10.4.zip" > /data/public/soy-admin/latest.zip && \
    unzip /data/public/soy-admin/latest.zip -d /data/public/soy-admin/ && \
    rm /data/public/soy-admin/latest.zip

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-command/releases/download/command-linux-plugin/command-linux-${ARCH}.so" > /plugins/command.so


USER root
VOLUME [ "/data" ]
WORKDIR /data
EXPOSE 5099
CMD ["sh", "init.sh"]