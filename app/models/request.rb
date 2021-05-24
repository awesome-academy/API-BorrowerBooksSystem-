class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :book

  validates :amount, presence: true,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.request.amount.min}
  validates :start_date, :end_date, presence: true

  validate :date_validation
  validate :amount_validation

  enum status: {pending: 0, approved: 1, rejected: 2, paid: 3, cancel: 4}

  private

  def date_validation
    return if start_date.blank? || end_date.blank?

    if start_date < Time.zone.today
      errors.add(:start_date, I18n.t("request.errors.start_date_before_today"))
    end
    return if end_date > start_date

    errors.add(:end_date, I18n.t("request.errors.end_date_before_start_date"))
  end

  def amount_validation
    return if book.nil?

    number_books_remaining = book.amount - book.requests.approved.sum(:amount)
    return if amount < number_books_remaining

    errors.add(:amount, I18n.t("request.errors.amount",
                               number: number_books_remaining))
  end
end
