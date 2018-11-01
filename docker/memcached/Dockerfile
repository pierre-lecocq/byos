FROM memcached:latest

USER root

ENV PACKAGES golang
ENV BUILD_PACKAGES wget

RUN apt-get update && \
    apt-get install -y $PACKAGES $BUILD_PACKAGES

RUN wget -q https://github.com/prometheus/memcached_exporter/releases/download/v0.5.0/memcached_exporter-0.5.0.linux-amd64.tar.gz && \
    tar xzf memcached_exporter-0.5.0.linux-amd64.tar.gz && \
    mv memcached_exporter-0.5.0.linux-amd64/memcached_exporter /usr/local/bin && \
    rm -rf memcached_exporter-0.5.0.linux-amd64*

RUN apt-get remove --purge -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

USER memcache

CMD ["memcached"]
