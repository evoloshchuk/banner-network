require 'sinatra'
require_relative 'config'
require 'rack/session/moneta'

class Application < Sinatra::Application

  enable :logging

  configure :production, :development do
    uri = URI.parse(CONFIG.redis_url)
    use Rack::Session::Moneta, :store => Moneta.new(:Redis,
                                                    :host => uri.host,
                                                    :port => uri.port,
                                                    :password => uri.password)
  end

  configure :test do
    use Rack::Session::Moneta, :store => :Memory
  end

end

Dir["models/*.rb"].each {|file| require_relative file }
Dir["controllers/*.rb"].each {|file| require_relative file }
Dir["lib/*.rb"].each {|file| require_relative file }
Dir["jobs/*.rb"].each {|file| require_relative file }
