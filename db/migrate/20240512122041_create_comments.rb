class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :post, null: false, foreign_key: true
      t.integer :user_id
      t.index :user_id

      t.timestamps
    end
  end
end
