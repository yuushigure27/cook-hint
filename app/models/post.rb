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

  validates :title, presence: true, length: { maximum: 20 }
  validates :introduction, presence: true, length: { maximum: 300 }
  validates :genre_id, presence: true
  
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :most_liked, -> { includes(:liked_users)
  .sort_by { |x| x.liked_users.includes(:likes).size }.reverse }

  attr_accessor :new_genre_name
  
  def self.search_for(keyword)
    Post.where('title LIKE ? OR introduction LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end
end

