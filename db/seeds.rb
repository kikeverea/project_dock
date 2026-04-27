puts "Seeding the db..."

users_then = User.count

User.find_or_create_by!(email: "admin@admin.com") do |user|
  user.password = "12341234"
  user.name = "Admin"
  user.lastname = "Innobing"
  user.role = :admin
end

client = Client.find_or_create_by!(name: "Kik balanga")

project = Project.find_or_create_by!(name: "Kik balanga - CRM") do |project|
  project.allocated_time = 100
  project.client = client
end

Activity.find_or_create_by!(project: project)
Activity.find_or_create_by!(project: project)

users_now = User.count

puts "🧑  #{users_now} users in the db — #{users_now - users_then} seeded"
