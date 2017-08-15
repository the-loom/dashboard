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
