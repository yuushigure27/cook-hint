class Post < ApplicationRecord
  belongs_to :genre
  has_one_attached :image
  
  validates :title, presence: true
  validates :introduction, presence: true
  
  
end
