FactoryBot.define do
  factory :request_book do
    amount { amount {rand(1...10)} }
  end
end
