require 'sinatra'
require 'resque'
require 'rack/session/moneta'
require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'libs/init'
require_relative 'jobs/init'

$redis_server = ENV.fetch("REDISTOGO_URL", 'http://127.0.0.1:6363')
Redis.current = Redis.new(:url => $redis_server)

class Application < Sinatra::Application

  enable :logging

  configure :production, :development do
    uri = URI.parse($redis_server)
    use Rack::Session::Moneta, :store => Moneta.new(:Redis,
                                                    :host => uri.host,
                                                    :port => uri.port,
                                                    :password => uri.password)
  end
  configure :test do
    use Rack::Session::Moneta, :store => :Memory
  end

end
