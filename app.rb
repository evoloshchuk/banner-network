require 'sinatra'
require 'resque'
require 'rack/session/moneta'
require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'libs/init'
require_relative 'jobs/init'

configure :production do
  @redis_server = ENV["REDISTOGO_URL"]
end

configure :development do
  @redis_server = 'http://127.0.0.1:6379'
end

Redis.current = Redis.new(:url => @redis_server)

class Application < Sinatra::Application

  enable :logging

  configure :production, :development do
    use Rack::Session::Moneta, :store => :Redis, :server => @redis_server
  end
  configure :test do
    use Rack::Session::Moneta, :store => :Memory
  end

end
