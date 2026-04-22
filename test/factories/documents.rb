FactoryBot.define do
  factory :document do
    name { Faker::Name.name }
    document_type { "document" }
    public { false }
    association :documentable, factory: :client
  end
end
