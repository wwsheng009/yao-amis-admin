#docker build --build-arg ARCH=amd64 --build-arg VERSION=0.10.5 --tag yao-amis-admin-dev .
#docker run -d --restart unless-stopped --name yao-amis-admin-dev -p 5099:5099 yao-amis-admin-dev

ARG ARCH
FROM wwsheng009/yao-${ARCH}:latest

ARG ARCH
ARG VERSION
WORKDIR /data


RUN addgroup -S -g 1000 yao && adduser -S -G yao -u 999 yao
RUN mkdir -p /data && curl -fsSL "https://github.com/wwsheng009/yao-amis-admin/releases/download/yao-amis-admin-${VERSION}/yao-amis-admin-${VERSION}.zip" > /data/latest.zip && \
    unzip /data/latest.zip && rm /data/latest.zip && \
    rm -rf /data/.git && \
    chown -R yao:yao /data && \
    chmod +x /data/init.sh && \
    chmod +x /usr/local/bin/yao && \
    cp /data/app.sample.yao /data/app.yao && \
    mkdir -p /data/plugins && \
    mkdir -p /data/db

# RUN mkdir -p /data

# ADD . /data

# RUN rm -rf /data/.git && \
#     rm -rf /data/.env* && \
#     rm -rf /data/Dockerfile* && \
#     chown -R yao:yao /data && \
#     chmod +x /data/init.sh && \
#     chmod +x /usr/local/bin/yao && \
#     mkdir -p /data/plugins && \
#     mkdir -p /data/db

RUN mkdir -p /data/public/amis-editor && \
    curl -fsSL "https://github.com/wwsheng009/amis-editor-yao/releases/download/1.1.0/amis-editor-1.1.0.zip" > /data/public/amis-editor/latest.zip && \
    unzip /data/public/amis-editor/latest.zip -d /data/public/amis-editor/ && \
    rm /data/public/amis-editor/latest.zip

RUN mkdir -p /data/public/soy-admin && \
    curl -fsSL "https://github.com/wwsheng009/soybean-admin-amis-yao/releases/download/0.10.4/soy-yao-admin-0.10.4.zip" > /data/public/soy-admin/latest.zip && \
    unzip /data/public/soy-admin/latest.zip -d /data/public/soy-admin/ && \
    rm /data/public/soy-admin/latest.zip

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-command/releases/download/command-linux-plugin/command-linux-${ARCH}.so" -o /data/plugins/command.so && \
    chmod +x /data/plugins/command.so

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-psutil/releases/download/psutil-linux-plugin/psutil-linux-${ARCH}.so" -o /data/plugins/psutil.so && \
    chmod +x /data/plugins/psutil.so

RUN curl -fsSL "https://github.com/wwsheng009/yao-plugin-email/releases/download/email-linux-plugin/email-linux-${ARCH}.so" -o /data/plugins/email.so && \
    chmod +x /data/plugins/email.so

RUN apk add --no-cache nodejs npm

WORKDIR /data
RUN npm i yarn -g
RUN yarn install --production

USER root
VOLUME [ "/data" ]
WORKDIR /data
EXPOSE 5099
CMD ["sh", "init.sh"]