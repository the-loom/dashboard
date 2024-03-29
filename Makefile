browser:
	google-chrome --new-window https://trello.com/b/ARo5MV67 http://localhost:3000 https://github.com/the-loom/dashboard https://rollbar.com/the-loom/all/items https://sentry.io/organizations/the-loom/issues/?project=5223497 https://app.codacy.com/manual/delucas/dashboard/dashboard

init:
	git config core.hooksPath .githooks

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

restart:
	echo "Restarting app..."
	$(MAKE) stop
	$(MAKE) start

just_db:
	docker-compose up -d db

build:
	$(MAKE) stop
	$(MAKE) init
	$(MAKE) mine
	docker-compose build
	docker-compose run app bundle install --no-deployment

migrate:
	docker-compose run app bundle exec rake db:migrate

rubocop:
	docker-compose run app bundle exec rubocop --auto-correct

fasterer:
	docker-compose run app bundle exec fasterer

rbp:
	docker-compose run app bundle exec rails_best_practices -f html .

routes:
	docker-compose run app bundle exec rake routes

logs:
	docker-compose logs -tf

app_logs:
	tail -f log/development.log

clean_logs:
	echo "" > log/development.log

tests:
	docker-compose run app rake db:test:prepare
	docker-compose run app ./bin/rake

use_production_db:
	$(MAKE) stop
	heroku pg:backups capture --app the-loom
	heroku pg:backups download --app the-loom
	mv latest.dump tmp/latest.dump
	docker-compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app bundle exec rake db:drop db:create
	docker cp tmp/latest.dump dashboard_db_1:/latest.dump
	! docker exec dashboard_db_1 pg_restore --verbose --clean --no-acl --no-owner -h localhost -d loom_development -U loom /latest.dump
	$(MAKE) migrate

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
	# marcar deploy con el nombre del backup?

emergency_deploy:
	git push -ff production master

sanitize_gemfile:
	docker-compose run app bundle exec pessimize
	docker-compose run app bundle exec ordinare

detect_where_in_views:
	grep -n -r -i --include \*.html.erb --include \*.html.haml .where . || true

detect_where_in_controllers:
	grep -n -r -i --include \*.rb .where ./app/controllers || true

add_production_repo:
	git remote add production https://git.heroku.com/the-loom.git

publish_and_deploy:
	git push origin master && git push production master
