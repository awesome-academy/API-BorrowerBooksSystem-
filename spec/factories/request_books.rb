FactoryBot.define do
  factory :request_book do
    amount {rand(1...10)}
    book {Book.first || association(:book)}
  end
end
