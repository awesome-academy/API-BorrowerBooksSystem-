class User < ApplicationRecord
  acts_as_paranoid

  has_many :requests, dependent: :destroy
  has_many :book_followers, dependent: :destroy
  has_many :followed_books, through: :book_followers,
            source: :book, dependent: :destroy

  validates :email, presence: true,
             format: {with: Settings.user.email.regex},
             length: {maximum: Settings.user.email.max_length},
             uniqueness: {case_sensitive: false}
  validates :name, presence: true,
            length: {maximum: Settings.user.name.max_length}
  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length}

  enum role: {user: 0, admin: 1}

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
