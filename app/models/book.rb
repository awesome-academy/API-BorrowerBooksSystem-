class Book < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  has_many :requests, dependent: :destroy
  has_many :book_followers, dependent: :destroy
  has_many :followers, through: :book_followers,
            source: :user, dependent: :destroy

  validates :title, presence: true,
            length: {maximum: Settings.book.title.max_length}
  validates :author, presence: true,
            length: {maximum: Settings.book.author.max_length}
  validates :amount, presence: true,
            numericality: {only_integer: true,
                           greater_than_or_equal_to: Settings.book.amount.min}
end
