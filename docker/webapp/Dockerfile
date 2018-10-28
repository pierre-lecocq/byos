FROM ruby:alpine

RUN apk --no-cache add build-base libpq cyrus-sasl-dev postgresql-dev wget

WORKDIR /tmp

RUN wget -q https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz && \
    tar xzf node_exporter-0.16.0.linux-amd64.tar.gz && \
    mv node_exporter-0.16.0.linux-amd64/node_exporter /usr/local/bin/

RUN gem install -N bundler \
    && bundle config --global silence_root_warning 1 \
    && echo -e 'gem: --no-document' >> /etc/gemrc

COPY Gemfile* /tmp/
RUN bundle check || bundle install

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "/etc/puma/puma.rb"]
