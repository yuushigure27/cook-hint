class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user
  has_one_attached :image
  
  validates :title, presence: true
  validates :introduction, presence: true
  
  
end
