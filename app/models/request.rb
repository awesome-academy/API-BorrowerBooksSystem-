class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :book

  enum status: {pending: 0, approved: 1, rejected: 2, paid: 3, cancel: 4}
end
