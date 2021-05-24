class AddDeletedAtToBookFollowers < ActiveRecord::Migration[6.1]
  def change
    add_column :book_followers, :deleted_at, :datetime
    add_index :book_followers, :deleted_at
  end
end
