FROM alpine:latest
MAINTAINER avpnusr

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    PYTHONIOENCODING='UTF-8'

COPY ./start.sh ./sickupdate /

RUN apk --update --no-cache add \
    git python py2-openssl tzdata unrar curl mediainfo nodejs libffi && \
    git clone https://github.com/SickChill/SickChill.git /sickchill && \
    chmod u+x /start.sh /sickupdate && \
    echo "20  3  *  *  *    /bin/sh /sickupdate > /dev/null" > /etc/crontabs/root && \
    apk del $buildDeps && \
    cd /sickchill && rm -rf tests .github Dockerfile docker-compose.yaml .gitattributes .gitignore .dockerignore .checkignore && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

COPY ./__init__.py /sickchill/sickbeard/

VOLUME ["/data", "/incoming", "/media"]

EXPOSE 8081

HEALTHCHECK --interval=120s --timeout=15s --start-period=120s --retries=3 \
            CMD wget --no-check-certificate --quiet --spider 'http://localhost:8081' || exit 1

WORKDIR /sickchill

CMD ["/start.sh"]
