class Post < ApplicationRecord
  belongs_to :genre, optional: true
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  
  def liked_by?(user)
    liked_users.include?(user)
  end

  validates :title, presence: true
  validates :introduction, presence: true
  validates :genre_id, presence: true

  attr_accessor :new_genre_name
  
  def self.looks(search, word)
    if search == "perfect_match"
      where("title LIKE ?", "#{word}")
    elsif search == "partial_match"
      where("title LIKE ?", "%#{word}%")
    else
      all
    end
  end
end

