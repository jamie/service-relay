require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

desc "Show all fields available from salesforce"
task :salesforce_debug do
  require './relay'
  force = Salesforce.new
  @cases = force.get_cases
  pp force.load_case(@cases.first['Id'])
end

