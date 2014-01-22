require 'rspec'
require 'rack/test'
require 'mock_redis'
require_relative '../app'

# Set the Sinatra environment
set :environment, :test

# Add an app method for RSpec
def app
  Application.new
end

RSpec.configure do |config|
  config.before(:each) do
    Redis.current = MockRedis.new
  end
end

include Rack::Test::Methods
