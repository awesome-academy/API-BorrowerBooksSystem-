class Category < ApplicationRecord
  has_many :books, dependent: :nullify
  has_many :child_categories, class_name: Category.name,
            foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
end
