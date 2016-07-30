# Web/Worker Containers Deployment (for Ruby App)

Summery:

- Experiments on container deployment for scripting language
- The size of production image is about 750MB

# Development

```
$ docker-compose run --rm bundler
$ docker-compose up dev_redis dev_web dev_worker
```

# Deployment

`make` runs below commands:

```
$ docker-compose build build
$ docker-compose run --rm build
$ docker-compose build dist_base
$ docker-compose build dist_web dist_worker
$ docker push registry.heroku.com/web-worker-containers-test/web
$ docker push registry.heroku.com/web-worker-containers-test/worker
```

# Reference

- https://github.com/mperham/sidekiq/blob/master/examples/sinkiq.rb
- https://github.com/mperham/sidekiq/wiki/Using-Redis
- https://github.com/puma/puma/wiki/Running-sinatra-classic-with-puma
- https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
