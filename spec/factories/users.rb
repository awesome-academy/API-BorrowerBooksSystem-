FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    password {"123123"}
    password_confirmation {"123123"}
  end
end
