class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.string :message
      t.boolean :read, default: false
      t.integer :visited_id  
      t.integer :post_id     
      t.string :action

      t.timestamps
    end

    add_foreign_key :notifications, :posts, column: :post_id  
  end
end