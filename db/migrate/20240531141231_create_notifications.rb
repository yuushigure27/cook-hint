class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.string :message
      t.boolean :read, default: false
      t.integer :visited_id  
      t.references :post, null:true, foreign_key: true
      t.string :action

      t.timestamps
    end

  end
end