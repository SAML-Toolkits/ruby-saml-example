# ruby version 2.0.2
FROM ruby:2.1

WORKDIR /onelogin/src
ADD . /onelogin/src

ENV BUNDLE_PATH=/bundle
RUN bundle install --verbose

ENV PORT 3003
EXPOSE 3003

ENV RAILS_ENV development
ENTRYPOINT ['./bin/bundle']
CMD ["exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
