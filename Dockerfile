FROM alpine:3.16

ENV CONFIG "/data/pghoard/config.json"
ENV POSTGRES_VERSION 13
ENV PGHOARD_VERSION 2.2.1

VOLUME /data/pghoard/
VOLUME /var/lib/postgresql/data/
VOLUME /data/backups/

RUN apk add --no-cache \
        tini \
        ca-certificates \
        python3 \
        snappy \
        libffi \
        postgresql$POSTGRES_VERSION \
        postgresql$POSTGRES_VERSION-client \
        nano \
        gettext && \
    apk add --no-cache --virtual .build-deps \
        musl-dev \
        python3-dev \
        postgresql$POSTGRES_VERSION-dev \
        snappy-dev \
        libffi-dev \
        gcc \
        g++ && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install boto cryptography && \
    wget https://github.com/aiven/pghoard/archive/refs/tags/$PGHOARD_VERSION.zip -O /tmp/pghoard.zip && \
    unzip /tmp/pghoard.zip -d /tmp && \
    python3 /tmp/pghoard-$PGHOARD_VERSION/setup.py install && \ 
    rm -r /root/.cache && \
    apk del .build-deps

COPY pghoard.json.template /pghoard.json.template
COPY pghoard.sh /

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "/pghoard.sh"]