class Category < ApplicationRecord
  acts_as_paranoid

  has_many :books, dependent: :destroy
  has_many :child_categories, class_name: Category.name,
            foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
end
