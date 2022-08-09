FROM alpine:3.16

ENV CONFIG "/data/pghoard/config.json" 

VOLUME /data/pghoard/

RUN apk add --no-cache \
        tini \
        ca-certificates \
        python3 \
        snappy \
        libffi \
        postgresql \
        postgresql-client \
        nano && \
    apk add --no-cache --virtual .build-deps \
        musl-dev \
        python3-dev \
        postgresql14-dev \
        snappy-dev \
        libffi-dev \
        gcc \
        g++ && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install boto cryptography pghoard && \
    rm -r /root/.cache && \
    apk del .build-deps

COPY pghoard.json.template /pghoard.json.template
COPY pghoard.sh /

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "/pghoard.sh"]