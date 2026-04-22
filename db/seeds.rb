puts "Seeding the db..."

users_then = User.count

User.find_or_create_by!(email: "admin@admin.com") do |user|
  user.password = "12341234"
  user.name = "Admin"
  user.lastname = "Innobing"
  user.role = :admin
end

users_now = User.count

puts "🧑  #{users_now} users in the db — #{users_now - users_then} seeded"
