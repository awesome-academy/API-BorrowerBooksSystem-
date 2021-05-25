class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :request_books, dependent: :destroy
  has_many :books, through: :request_books,
            source: :book, dependent: :destroy

  validates :start_date, :end_date, presence: true

  validate :date_validation

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
end
