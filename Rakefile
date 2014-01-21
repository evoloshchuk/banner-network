# encoding: utf-8

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
