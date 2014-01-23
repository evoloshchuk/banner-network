web: bundle exec thin -R config.ru start -p $PORT
worker: env TERM_CHILD=1 env QUEUE=* bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler
