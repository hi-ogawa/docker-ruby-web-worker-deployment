deploy:
	docker-compose build build
	docker-compose run --rm build
	docker-compose build dist_base
	docker-compose build dist_web dist_worker
	docker push registry.heroku.com/web-worker-containers-test/web
	docker push registry.heroku.com/web-worker-containers-test/worker
