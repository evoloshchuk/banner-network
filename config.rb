# General configuration.

require 'ostruct'

CONFIG = OpenStruct.new

# Heroku provide redis url in the env variable REDISTOGO_URL
CONFIG.redis_url = ENV.fetch("REDISTOGO_URL", 'http://127.0.0.1:6363')

require 'redis'
Redis.current = Redis.new(:url => CONFIG.redis_url)
