#docker build --platform linux/amd64 --tag demo-project .
#docker run -d --restart unless-stopped --name demo-project -p 5099:5099 demo-project
FROM wwsheng009/yao:0.10.4-amd64-release
ARG VERSION

WORKDIR /data

#COPY yao /usr/local/bin/yao cp /data/docker.env /data/.env && \
#RUN apk add git
RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
RUN mkdir -p /data/app && curl -fsSL "https://github.com/wwsheng009/yao-amis-admin/releases/download/yao-amis-admin-${VERSION}/yao-amis-admin-${VERSION}.zip" > /data/app/latest.zip && \
    unzip /data/app/latest.zip && rm /data/app/latest.zip && \
    rm -rf /data/app/.git && \
    chown -R yao:yao /data && \
    chmod +x /data/init.sh && \
    chmod +x /usr/local/bin/yao && \
    cp /data/docker.env /data/.env && \
    cp /data/app.sample.yao /data/app.yao && \
    mkdir -p /data/db

RUN mkdir -p /data/app/public/amis-editor && \
    curl -fsSL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.0.0/amis-editor-1.0.0.zip" > /data/app/public/amis-editor/latest.zip && \
    unzip /data/app/public/amis-editor/latest.zip && \
    rm /data/app/public/amis-editor/latest.zip

RUN mkdir -p /data/app/public/soy-admin && \
    curl -fsSL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/0.10.4/soy-yao-admin-0.10.4.zip" > /data/app/public/soy-admin/latest.zip && \
    unzip /data/app/public/soy-admin/latest.zip && \
    rm /data/app/public/soy-admin/latest.zip

USER root
VOLUME [ "/data" ]
WORKDIR /data
EXPOSE 5099
CMD ["sh", "init.sh"]