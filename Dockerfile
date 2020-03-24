FROM ruby:2.5.5-alpine AS base

RUN apk add --no-cache libcurl libpq nodejs tzdata && \
  gem install bundler -v "~>2" && \
  rm -vf /usr/local/bundle/cache/*.gem && \
  adduser -Dh /app app
WORKDIR /app

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

FROM base AS build

RUN apk add --no-cache build-base git postgresql-dev yarn
USER app

COPY --chown=app:app Gemfile* ./
RUN bundle config --local deployment 'true' && \
  bundle config --local without $(echo 'development test' | sed "s/\\s*$RAILS_ENV\\s*//g") && \
  bundle install && \
  rm -vf /usr/local/bundle/ruby/*/cache/*.gem

ARG NODE_ENV=${RAILS_ENV}
ENV NODE_ENV=${NODE_ENV}

COPY --chown=app:app . .
RUN SECRET_KEY_BASE=$(printf %128s | tr ' ' '0') bundle exec rails assets:precompile && \
  rm -r log tmp

FROM base
USER app

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=app:app --from=build /app .
ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
