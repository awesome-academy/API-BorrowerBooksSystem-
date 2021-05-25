FactoryBot.define do
  factory :book do
    title {Faker::Book.name}
    author {Faker::Book.author}
    amount {rand(10..100)}
    description {Faker::Lorem.sentence(word_count: 5)}
  end
end
