source 'https://rubygems.org'

ruby '2.1.0'

# A light-weight Ruby framework.
gem 'sinatra', '1.4.3'

# A library providing Rubyish interface to Redis.
gem 'redis-objects', '0.8.0'

# An unified interface to key/value stores. Used for session handling.
gem 'moneta', '0.7.20'

# A thin and fast web server.
gem 'thin', '1.6.1'

# A library for creating background jobs.
gem 'resque', '1.25.1'

# A library for scheduling background jobs.
gem 'resque-scheduler', '2.3.1', :require => 'resque_scheduler'

# A process manager for applications.
gem 'foreman', '0.63.0'

group :development, :test do
  # Reloading rack development server.
  gem 'shotgun', '0.9'

  # Rails-based frontend to the Resque job queue system.
  gem 'resque-web', '0.0.4', require: 'resque_web'

  # Testing tool for the Ruby.
  gem 'rspec', '2.14.1'

  # Mocking facilities for Redis.
  gem 'mock_redis', '0.10.0'
end
