class RequestBook < ApplicationRecord
  acts_as_paranoid

  belongs_to :request
  belongs_to :book

  validates :amount, presence: true,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.request.amount.min}

  validate :amount_validation

  private

  def amount_validation
    return if book.nil?

    books_remaining = book.amount - Book.books_borrowed(book)
    return if amount < books_remaining

    errors.add(:amount, I18n.t("request.errors.amount",
                               number: books_remaining))
  end
end