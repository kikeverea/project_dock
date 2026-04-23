namespace :db do
  desc "Drop, create, migrate, and seed the database"
  task nuke: %w[db:drop db:create] do
    schema = Rails.root.join("db/schema.rb")
    schema.delete if schema.exist?
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end
