class User < ApplicationRecord
  acts_as_paranoid

  has_many :requests, dependent: :destroy
  has_many :book_followers, dependent: :destroy
  has_many :followed_books, through: :book_followers,
            source: :book, dependent: :destroy

  enum role: {user: 0, admin: 1}

  has_secure_password
end
