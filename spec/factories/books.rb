FactoryBot.define do
  factory :book do
    title {Faker::Book.title}
    author {Faker::Book.author}
    amount {rand(10..100)}
    description {Faker::Lorem.sentence(word_count: 5)}
    category {Category.first || association(:category)}
  end
end
