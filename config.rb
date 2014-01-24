# General configuration.

require 'ostruct'

$config = OpenStruct.new

# Heroku provide redis url in the env variable REDISTOGO_URL
$config.redis_url = ENV.fetch("REDISTOGO_URL", 'http://127.0.0.1:6363')

require 'redis'
Redis.current = Redis.new(:url => $config.redis_url)
