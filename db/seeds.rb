# Create a admin user.
User.create! name: "Admin",
             email: "admin@gmail.com",
             password: "123123",
             password_confirmation: "123123",
             role: User.roles[:admin]

# Generate users.
20.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@gmail.com"
  password = "123123"
  User.create! name: name,
               email: email,
               password: password,
               password_confirmation: password
end

# Generate categories.
10.times do
  name = Faker::Lorem.sentence(word_count: 2)
  Category.create! name: name
end

# Generate books.
50.times do
  title = Faker::Book.title
  author = Faker::Book.author
  description = Faker::Lorem.sentence(word_count: 5)
  Book.create! title: title,
               author: author,
               description: description,
               amount: rand(50..100),
               category: Category.all.sample
end

# Generate requests.
100.times do
  start_date = Faker::Date.between(from: Date.today, to: Date.today + 1.month)
  end_date = Faker::Date.between(from: start_date + 1.day, to: start_date + 1.month)
  Request.create! start_date: start_date,
                  end_date: end_date,
                  status: rand(0..4),
                  user: User.all.sample
end

# Generate request book.
Request.all.each do |request|
  rand(1..5).times do
    RequestBook.create! amount: rand(1..5),
                        request: request,
                        book: Book.all.sample
  end
end

# Generate book followers.
User.take(7).each do |user|
  10.times do
    BookFollower.create! user: user,
                         book: Book.all.sample
  end
end
