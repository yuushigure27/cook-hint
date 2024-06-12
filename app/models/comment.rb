class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { maximum: 300 }
  
  scope :best_answer, -> { where(best_answer: true) }
  
  def unmark_best_answer
    update(best_answer: false)
  end
end
