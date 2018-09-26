start:
	rm -f tmp/pids/server.pid
	docker-compose up -d

from_scratch:
	docker-compose run app rake db:setup db:seed

stop:
	docker-compose down
	rm -f tmp/pids/server.pid

just_db:
	docker-compose up -d db

rebuild:
	docker-compose build

rubocop:
	docker-compose run app rubocop -a

logs:
	docker-compose logs -tf

capture_production_db:
	heroku pg:backups capture --app the-loom
	$(MAKE) download_production_db

download_production_db:
	curl -o tmp/latest.dump `heroku pg:backups public-url --app the-loom`

restore_production_db:
	docker-compose run app bundle exec rake db:drop db:create
	docker cp tmp/latest.dump loomdashboard_db_1:/latest.dump
	! docker exec loomdashboard_db_1 pg_restore --verbose --clean --no-acl --no-owner -h localhost -d loom_development -U loom /latest.dump
	docker-compose run app bundle exec rake db:migrate

capture_and_clone_production_db_to_development:
	$(MAKE) capture_production_db
	$(MAKE) restore_production_db

download_and_clone_production_db_to_development:
	$(MAKE) download_production_db
	$(MAKE) restore_production_db

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
	heroku pg:reset --app the-loom --confirm the-loom
	heroku run rake db:migrate --app the-loom
	heroku ps:scale web=1 --app the-loom
	heroku restart --app the-loom
	heroku maintenance:off --app the-loom
