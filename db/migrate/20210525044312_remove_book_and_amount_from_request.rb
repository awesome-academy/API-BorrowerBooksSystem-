class RemoveBookAndAmountFromRequest < ActiveRecord::Migration[6.1]
  def change
    remove_column :requests, :amount, :integer
    remove_reference :requests, :book, null: false, foreign_key: true
  end
end
