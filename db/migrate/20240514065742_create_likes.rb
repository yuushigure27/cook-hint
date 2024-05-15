class CreateLikes < ActiveRecord::Migration[6.1]
  def change
   create_table :likes do |t|
     t.references :user, null: false, foreign_key: true
     t.references :post, null: false, foreign_key: true
     #null: falseを付与
     
     t.timestamps
   end
   add_index :likes, [:user_id, :post_id], unique: true
   #user_idとpost_idの組み合わせが一意になるように(複合キー)設定
  end
end