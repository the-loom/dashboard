FROM ruby:2.6.1

RUN useradd -u 1000 --create-home --home-dir /xyz --shell /bin/bash loom

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends postgresql-client \
  && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD rails server -b 0.0.0.0
