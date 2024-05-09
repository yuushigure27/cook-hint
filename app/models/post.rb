class Post < ApplicationRecord
  belongs_to :genre, optional: true
  belongs_to :user
  has_one_attached :image
  
  validates :title, presence: true
  validates :introduction, presence: true
  
  attr_accessor :new_genre_name
  
end
