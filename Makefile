capture_production_db:
	heroku pg:backups capture --app the-loom
	$(MAKE) download_production_db

download_production_db:
	curl -o tmp/latest.dump `heroku pg:backups public-url --app the-loom`

restore_production_db:
	foreman run bundle exec rake db:drop db:create
	! pg_restore --verbose --clean --no-acl --no-owner -h localhost -d loom-dashboard -U loom tmp/latest.dump
	foreman run bundle exec rake db:migrate

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
