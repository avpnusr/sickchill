FROM alpine:3.12
MAINTAINER avpnusr

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    PYTHONIOENCODING='UTF-8' \
    SCBRANCH='v2019.09.02-1'

COPY ./start.sh ./__init__.py ./indexer_config.py ./showUpdater.py ./tvdb_api.py /

RUN buildDeps="gcc python-dev openssl-dev libffi-dev musl-dev py2-setuptools" && \
    apk --update --no-cache add $buildDeps --repository http://dl-3.alpinelinux.org/alpine/v3.11/main/ && \
    apk --update --no-cache add \
    git python2 tzdata unrar curl nodejs shadow su-exec libxslt && \
    python2 -m ensurepip --upgrade && \
    pip install --upgrade pip --no-cache-dir && \
    python2 -m pip install pyopenssl --no-cache-dir && \
    git clone -b ${SCBRANCH} https://github.com/SickChill/SickChill.git /sickchill && \
    cd /sickchill && rm -rf .git tests .github Dockerfile docker-compose.yaml .gitattributes .gitignore .dockerignore .checkignore && \
    chmod u+x /start.sh && \
    apk del $buildDeps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

VOLUME ["/data", "/incoming", "/media"]

EXPOSE 8081

HEALTHCHECK --interval=120s --timeout=15s --start-period=120s --retries=3 \
            CMD wget --no-check-certificate --quiet --spider 'http://localhost:8081' || exit 1

ENTRYPOINT [ "/bin/sh", "/start.sh" ]
