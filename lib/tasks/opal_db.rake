namespace :opal_db do
  desc "Resets the database with the given schema file."
  task :setup do
    # puts ENV["schema"]
    require "./lib/opal_orm/schema_manager.rb"
    # OpalORM::SchemaManager.test
    instance_eval File.read("./db/#{ENV["schema"]}")
  end
end
