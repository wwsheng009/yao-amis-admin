#docker build --build-arg ARCH=amd64 --build-arg VERSION=0.10.5 --tag yao-amis-admin-dev .
#docker run -d --restart unless-stopped --name yao-amis-admin-dev -p 5099:5099 yao-amis-admin-dev

ARG ARCH
FROM wwsheng009/yao-${ARCH}:latest

ARG ARCH
ARG VERSION
WORKDIR /data/app


RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
RUN mkdir -p /data/app && curl -fsSL "https://github.com/wwsheng009/yao-amis-admin/releases/download/yao-amis-admin-${VERSION}/yao-amis-admin-${VERSION}.zip" > /data/app/latest.zip && \
    unzip /data/app/latest.zip && rm /data/app/latest.zip && \
    rm -rf /data/app/.git && \
    chown -R yao:yao /data/app && \
    chmod +x /data/app/init.sh && \
    chmod +x /usr/local/bin/yao && \
    cp /data/app/app.sample.yao /data/app/app.yao && \
    mkdir -p /data/app/plugins && \
    mkdir -p /data/app/db

# RUN mkdir -p /data/app

# ADD . /data/app

# RUN rm -rf /data/app/.git && \
#     rm -rf /data/app/.env* && \
#     rm -rf /data/app/Dockerfile* && \
#     chown -R yao:yao /data/app && \
#     chmod +x /data/app/init.sh && \
#     chmod +x /usr/local/bin/yao && \
#     mkdir -p /data/app/plugins && \
#     mkdir -p /data/app/db

RUN mkdir -p /data/app/public/amis-editor && \
    curl -fsSL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.1.0/amis-editor-1.1.0.zip" > /data/app/public/amis-editor/latest.zip && \
    unzip /data/app/public/amis-editor/latest.zip -d /data/app/public/amis-editor/ && \
    rm /data/app/public/amis-editor/latest.zip

RUN mkdir -p /data/app/public/soy-admin && \
    curl -fsSL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/0.10.4/soy-yao-admin-0.10.4.zip" > /data/app/public/soy-admin/latest.zip && \
    unzip /data/app/public/soy-admin/latest.zip -d /data/app/public/soy-admin/ && \
    rm /data/app/public/soy-admin/latest.zip

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-command/releases/download/command-linux-plugin/command-linux-${ARCH}.so" -o /data/app/plugins/command.so && \
    chmod +x /data/app/plugins/command.so

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-psutil/releases/download/psutil-linux-plugin/psutil-linux-${ARCH}.so" -o /data/app/plugins/psutil.so && \
    chmod +x /data/app/plugins/psutil.so

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-email/releases/download/email-linux-plugin/email-linux-${ARCH}.so" -o /data/app/plugins/email.so && \
    chmod +x /data/app/plugins/email.so

RUN apk add --no-cache nodejs npm

WORKDIR /data/app
RUN npm i yarn -g
RUN yarn install --production

USER root
VOLUME [ "/data/app" ]
WORKDIR /data/app
EXPOSE 5099
CMD ["sh", "init.sh"]