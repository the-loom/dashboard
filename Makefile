browser:
	google-chrome --new-window https://trello.com/b/ARo5MV67/the-loom http://localhost:3000

start:
	rm -f tmp/pids/server.pid
	docker-compose up -d

console:
	docker-compose run app rails console

mine:
	sudo chown -R 1000:1000 .

dev_seed:
	docker-compose run app rake db:setup db:seed

dev_admin:
	docker-compose run app rake dev:admin_setup

dev_courses:
	docker-compose run app rake dev:courses_setup

dev_teacher:
	docker-compose run app rake dev:teacher_setup

dev_all:
	$(MAKE) dev_courses
	$(MAKE) dev_teacher
	$(MAKE) dev_admin

stop:
	docker-compose down
	rm -f tmp/pids/server.pid

just_db:
	docker-compose up -d db

build:
	docker-compose build
	docker-compose run app bundle

migrate:
	docker-compose run app rake db:migrate

rubocop:
	docker-compose run app rubocop --auto-correct

routes:
	docker-compose run app rake routes

logs:
	docker-compose logs -tf

app_logs:
	tail -f log/development.log

tests:
	docker-compose run app rake db:test:prepare
	docker-compose run app ./bin/rake

use_production_db:
	heroku pg:backups capture --app the-loom
	curl -o tmp/latest.dump `heroku pg:backups public-url --app the-loom`
	docker-compose run app bundle exec rake db:drop db:create
	docker cp tmp/latest.dump loom-dashboard_db_1:/latest.dump
	! docker exec loom-dashboard_db_1 pg_restore --verbose --clean --no-acl --no-owner -h localhost -d loom_development -U loom /latest.dump
	docker-compose run app bundle exec rake db:migrate

cleanup_download:
	rm tmp/latest.dump

staging_deploy:
	heroku maintenance:on --app the-loom-staging
	git push -ff staging `git rev-parse --abbrev-ref HEAD`:master
	heroku pg:killall --app the-loom-staging
	heroku pg:reset --app the-loom-staging --confirm the-loom-staging
	heroku run rake db:migrate --app the-loom-staging
	heroku run rake db:seed --app the-loom-staging
	heroku ps:scale web=1 --app the-loom-staging
	heroku restart --app the-loom-staging
	heroku maintenance:off --app the-loom-staging

production_deploy:
	heroku maintenance:on --app the-loom
	git push -ff production master
	heroku pg:killall --app the-loom
	heroku run rake db:migrate --app the-loom
	heroku ps:scale web=1 --app the-loom
	heroku restart --app the-loom
	heroku maintenance:off --app the-loom
