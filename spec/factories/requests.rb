FactoryBot.define do
  factory :request do
    start_date {Faker::Date.between(from: Date.today, to: Date.today + 1.month)}
    end_date {Faker::Date.between(from: start_date + 1.day, to: start_date + 1.month)}
  end
end
