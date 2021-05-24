class User < ApplicationRecord
  acts_as_paranoid

  has_many :requests, dependent: :destroy
  has_many :book_followers, dependent: :destroy
  has_many :followed_books, through: :book_followers,
            source: :book, dependent: :destroy
end
