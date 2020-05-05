[![Build Status](https://travis-ci.org/the-loom/dashboard.svg?branch=master)](https://travis-ci.org/the-loom/dashboard)

# The Loom: dashboard

loom es una aplicación web que acompaña a los estudiantes en su cursada

## Setup

```shell
  cp .env.example .env
  nano .env
  make build
  docker-compose run app rake db:setup
```  

## Running the app

```shell
  make start
```

## Developer helpers

In order to load seeds, run

```shell
  make dev_seed
```

You'll get three courses with students. You need to log-in now.

After logged in, you might want to do some or all of these actions:

```shell
  # make yourself admin
  make dev_admin

  # subscribe yourself to all courses at once
  make dev_courses

  # promote yourself as teacher (only for your courses)
  make dev_teacher
```

Tip: A shorthand for all three actions is `make dev_all`

## Stopping the app

```shell
  make stop
```
