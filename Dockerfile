FROM alpine:latest
MAINTAINER avpnusr

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    PYTHONIOENCODING='UTF-8'

COPY ./start.sh ./sickupdate ./__init__.py /

RUN buildDeps="gcc python-dev openssl-dev libffi-dev musl-dev py2-pip" && \
    apk --update --no-cache add $buildDeps && \
    apk --update --no-cache add \
    git python2 tzdata unrar curl nodejs && \
    pip install --upgrade pip --no-cache-dir && \
    pip install pyopenssl --no-cache-dir && \
    git clone https://github.com/SickChill/SickChill.git /sickchill && \
    cd /sickchill && rm -rf .git tests .github Dockerfile docker-compose.yaml .gitattributes .gitignore .dockerignore .checkignore && \
    chmod u+x /start.sh /sickupdate && \
    echo "20  3  *  *  *    /bin/sh /sickupdate > /dev/null" > /etc/crontabs/root && \
    apk del $buildDeps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

VOLUME ["/data", "/incoming", "/media"]

EXPOSE 8081

HEALTHCHECK --interval=120s --timeout=15s --start-period=120s --retries=3 \
            CMD wget --no-check-certificate --quiet --spider 'http://localhost:8081' || exit 1

ENTRYPOINT [ "/bin/sh", "/start.sh" ]
