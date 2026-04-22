FactoryBot.define do
  factory :job_candidate do
    name { Faker::Name.name }
    lastname { Faker::Name.last_name }
    birthdate { Faker::Date.birthday }
    primary_email { Faker::Internet.email }
    observations { Faker::Lorem.sentence }
  end
end
