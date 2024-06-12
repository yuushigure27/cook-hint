class AddBestAnswerToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :best_answer, :boolean
  end
end
