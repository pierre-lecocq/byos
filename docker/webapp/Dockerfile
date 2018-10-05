FROM ruby:alpine

RUN apk --no-cache add build-base \
                       libpq \
                       cyrus-sasl-dev \
                       postgresql-dev

WORKDIR /tmp

RUN gem install -N bundler \
    && bundle config --global silence_root_warning 1 \
    && echo -e 'gem: --no-document' >> /etc/gemrc

COPY Gemfile* /tmp/
RUN bundle check || bundle install

CMD ["bundle", "exec", "puma", "-C", "/etc/puma/puma.rb"]
