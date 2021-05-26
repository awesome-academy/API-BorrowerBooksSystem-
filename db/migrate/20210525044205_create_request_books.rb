class CreateRequestBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :request_books do |t|
      t.integer :amount, null: false
      t.references :request, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
