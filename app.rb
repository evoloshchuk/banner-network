require 'sinatra'
require 'resque'
require 'rack/session/moneta'
require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'libs/init'
require_relative 'jobs/init'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Application < Sinatra::Application

  enable :logging

  configure :production do
    set :port, ENV['port']
  end

  configure :production, :development do
    use Rack::Session::Moneta, :store => :Redis
  end
  configure :test do
    use Rack::Session::Moneta, :store => :Memory
  end

end
