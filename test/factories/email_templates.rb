FactoryBot.define do
  factory :email_template do
    name { EmailTemplate.names.keys.sample }
    subject { Faker::Lorem.sentence }
  end
end
