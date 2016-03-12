require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./lib/opal_orm"
require_relative "lib/opal_orm/schema_manager"
import "./lib/tasks/opal_db.rake"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
