require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'rake/testtask'

task "resque:setup" do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  require 'redis'
  require 'yaml'

  Resque.redis = Redis.new
  Resque.schedule = YAML.load_file('resque_schedule.yml')

  require_relative 'jobs/init'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)


task "warmup" do
  require_relative 'app'
  require_relative 'jobs/init'
  quarter = 1 + Time.now.min / 15
  impressions_fn = "./data/#{quarter}/impressions_#{quarter}.csv"
  clicks_fn = "./data/#{quarter}/clicks_#{quarter}.csv"
  conversions_fn = "./data/#{quarter}/conversions_#{quarter}.csv"
  UpdateJob.perform(impressions_fn, clicks_fn, conversions_fn)
end
