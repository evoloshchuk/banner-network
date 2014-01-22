require 'sinatra'
require 'resque'
require_relative 'models/init'
require_relative 'controllers/init'
require_relative 'libs/init'
require_relative 'jobs/init'

Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

class Application < Sinatra::Application
  enable :logging
  enable :sessions
  set :session_secret, "sa7#6{38b@*&dd"
end
