FactoryBot.define do
  factory :request do
    user {User.first || association(:user)}
    start_date {Faker::Date.between(from: Date.today, to: Date.today + 1.month)}
    end_date {Faker::Date.between(from: start_date + 1.day, to: start_date + 1.month)}
    before :create do |request|
      request.request_books = build_list :request_book, 2, request: request
    end
  end
end
