#!/bin/bash

heroku pg:backups capture --app the-loom
curl -o the-loom-`date +"%Y%m%d"`.dump `heroku pg:backups public-url --app the-loom`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U loom -d loom-dashboard the-loom-`date +"%Y%m%d"`.dump
