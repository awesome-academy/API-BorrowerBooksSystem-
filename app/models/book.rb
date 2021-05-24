class Book < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  has_many :requests, dependent: :destroy
  has_many :book_followers, dependent: :destroy
  has_many :followers, through: :book_followers,
            source: :user, dependent: :destroy
end
