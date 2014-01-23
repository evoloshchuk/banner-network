require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'rake/testtask'
require_relative 'app'

task "resque:setup" do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  require 'redis'
  require 'yaml'

  Resque.redis = Redis.current
  resque_schedule = File.open("resque_schedule.yml").read
  resque_schedule = resque_schedule % {root: settings.root}
  Resque.schedule = YAML.load(resque_schedule)

  require_relative 'jobs/init'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)


task "warmup" do
  require_relative 'jobs/init'
  quarter = 1 + Time.now.min / 15
  root = settings.root
  impressions_fn = "#{root}/data/#{quarter}/impressions_#{quarter}.csv"
  clicks_fn = "#{root}/data/#{quarter}/clicks_#{quarter}.csv"
  conversions_fn = "#{root}/data/#{quarter}/conversions_#{quarter}.csv"
  UpdateJob.perform(impressions_fn, clicks_fn, conversions_fn)
end
