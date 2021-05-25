class AddDeleteAtToRequestBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :request_books, :deleted_at, :datetime
    add_index :request_books, :deleted_at
  end
end
