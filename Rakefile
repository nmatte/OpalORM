require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./lib/opal_orm"
require_relative "lib/opal_orm/schema_manager"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :wtf do
  puts "wtf"
end

namespace :opal_db do
  desc "Resets the database with the given schema file."
  task :setup do
    # puts ENV["schema"]
    require "./lib/opal_orm/schema_manager.rb"
    # OpalORM::SchemaManager.test
    instance_eval File.read("./db/#{ENV["schema"]}")
  end
end
