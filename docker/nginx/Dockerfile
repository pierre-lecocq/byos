FROM nginx:alpine

RUN apk --no-cache add build-base libpq cyrus-sasl-dev postgresql-dev wget

WORKDIR /tmp

RUN wget -q https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.1.0/nginx-prometheus-exporter-0.1.0-linux-amd64.tar.gz && \
    tar xzf nginx-prometheus-exporter-0.1.0-linux-amd64.tar.gz && \
    mv nginx-prometheus-exporter /usr/local/bin/ && \
    rm -rf nginx-prometheus-exporter-0.1.0-linux-amd64*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
