############ os_deps ############
FROM ubuntu:18.04 AS os_deps

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN date --utc
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  software-properties-common
RUN add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get update
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ruby2.3=2.3.8-4bbox1~bionic1 \
  git \
  ruby2.3-dev=2.3.8-4bbox1~bionic1 \
  build-essential=12.4ubuntu1 \
  patch=2.7.6-2ubuntu1.1 \
  zlib1g-dev=1:1.2.11.dfsg-0ubuntu2 \
  liblzma-dev=5.2.2-1.3 \
  libpq-dev \
  libmagickwand-dev=8:6.9.7.4+dfsg-16ubuntu6.8 \
  tzdata

RUN gem update --system 3.0.6
RUN gem install bundler -v 1.17.3
RUN echo "Package versions" && \
  apt-cache policy software-properties-common && \
  apt-cache policy ruby2.3 && \
  apt-cache policy git && \
  apt-cache policy ruby2.3-dev && \
  apt-cache policy build-essential && \
  apt-cache policy patch && \
  apt-cache policy zlib1g-dev && \
  apt-cache policy liblzma-dev && \
  apt-cache policy libpq-dev && \
  apt-cache policy libmagickwand-dev && \
  apt-cache policy tzdata

############ ruby_deps ############
FROM os_deps AS ruby_deps

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY vendor vendor
# Or just run bundle install --deployment (or whatever it's called)
COPY install-gems.sh install-gems.sh
COPY load_path.rb load_path.rb
RUN ./install-gems.sh

############ project_files ############

FROM ruby_deps AS project_files

WORKDIR /app

COPY app app
COPY bin bin
COPY config config
COPY db db
COPY doc doc
COPY script script
COPY lib lib
RUN mkdir -p log
COPY public public
RUN mkdir -p tmp/cache/assets/sprockets/v3.0 && \
  mkdir -p tmp/data/meta_request && \
  mkdir -p tmp/delayed_job_pids && \
  mkdir -p tmp/pids && \
  mkdir -p tmp/sessions && \
  mkdir -p tmp/sockets
COPY config.ru config.ru
COPY Rakefile Rakefile

############ build ############

FROM project_files AS build

WORKDIR /app

ARG app_env=production
ENV PATH="/app/bin:/app/exe:/app/gems/ruby/2.3.0/bin:${PATH}"
ENV RAILS_ENV=$app_env
ENV DATABASE_USERNAME=dummy
ENV DATABASE_NAME=dummy
ENV DATABASE_PASSWORD=dummy
ENV SECRET_KEY_BASE=dummy
ENV DEVISE_KEY_BASE=dummy

RUN echo "$PWD" && \
  echo "$PATH" && \
  gem --version && \
  ruby --version && \
  which rake
RUN rm -rf log && \
  rm -rf tmp && \
  rm -rf public/system && \
  rm -rf public/ckeditor_assets

############ release ############

FROM build AS release

WORKDIR /
RUN mkdir -p /release
RUN cp -aT /app/. /release/
# RUN chmod --recursive 755 /release

############ deb ############

FROM os_deps AS deb

WORKDIR /app

COPY deploy/deb/web/ ./
RUN mkdir -p ./opt/MYPKGNAME
COPY --from=release /release/ ./opt/MYPKGNAME
RUN ls -la /app && ls -la /app/opt
RUN chmod -R 755 ./DEBIAN
RUN dpkg-deb --build . MYPKGNAME.deb
