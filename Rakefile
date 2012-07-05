require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task :environment do
  require './lib/environment'
end

desc "Show all fields available from salesforce"
task :salesforce_debug do
  require './relay'
  force = Salesforce.new
  @cases = force.get_cases
  pp force.load_case(@cases.first['Id'])
  #puts SalesforcePivotalFormatter.new(@cases).to_xml
end

desc "Send a manual message to hipchat"
task :hipchat_say => :environment do
  hipchat = Hipchat.new(ENV['HIPCHAT_TOKEN'], ENV['HIPCHAT_ROOM'])
  hipchat.send('Test', ENV['MSG'], ENV['COLOR'])
end
