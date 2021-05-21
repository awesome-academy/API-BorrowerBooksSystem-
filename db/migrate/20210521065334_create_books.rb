class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.integer :amount, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
