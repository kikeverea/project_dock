namespace :db do
  desc "Drop, create, migrate, and seed the database"
  task nuke: ["db:drop", "db:create", "db:migrate", "db:seed"]
end
