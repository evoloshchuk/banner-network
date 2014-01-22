web: bundle exec thin -R config.ru start -p $PORT -e $RACK_ENV
worker: env TERM_CHILD=1 env QUEUE=* bundle exec rake resque:work RACK_ENV=$RACK_ENV
scheduler: bundle exec rake resque:scheduler RACK_ENV=$RACK_ENV
