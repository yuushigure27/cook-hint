class Post < ApplicationRecord
  belongs_to :genre, optional: true
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  
  def liked_by?(user)
    liked_users.include?(user)
  end

  validates :title, presence: true
  validates :introduction, presence: true
  validates :genre_id, presence: true

  attr_accessor :new_genre_name

end
