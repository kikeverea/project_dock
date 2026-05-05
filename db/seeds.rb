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

Activity.find_or_create_by!(project: project) do |activity|
  activity.generating_interaction = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
end

users_now = User.count

puts "🧑  #{users_now} users in the db — #{users_now - users_then} seeded"
