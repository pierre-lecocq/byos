FROM postgres:10

ENV PACKAGES golang sudo
ENV BUILD_PACKAGES wget

RUN apt-get update && \
    apt-get install -y $PACKAGES $BUILD_PACKAGES

RUN usermod -a -G sudo postgres

RUN wget -q https://github.com/wrouesnel/postgres_exporter/releases/download/v0.4.6/postgres_exporter_v0.4.6_linux-amd64.tar.gz && \
    tar xzf postgres_exporter_v0.4.6_linux-amd64.tar.gz && \
    mv postgres_exporter_v0.4.6_linux-amd64/postgres_exporter /usr/local/bin && \
    rm -rf postgres_exporter_v0.4.6_linux-amd64

RUN apt-get remove --purge -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

USER postgres

CMD ["postgres"]
