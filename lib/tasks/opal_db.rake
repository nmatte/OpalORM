require_relative "../opal_orm/schema_manager.rb"

namespace :opal_db do
  desc "Resets the database with the given schema file."
  task :setup do

    OpalORM::SchemaManager.new.instance_eval File.read("./db/#{ENV["schema"]}")
  end
end
