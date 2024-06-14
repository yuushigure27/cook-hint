class Post < ApplicationRecord
  belongs_to :genre, optional: true
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  
  def best_answer?
    comments.best_answer.exists?
  end
  
  def liked_by?(user)
    liked_users.include?(user)
  end
  
  def best_answer_comment
    comments.find_by(best_answer: true)
  end

  def has_best_answer?
    best_answer_comment.present?
  end

  validates :title, presence: true, length: { maximum: 20 }
  validates :introduction, presence: true, length: { maximum: 300 }
  validates :genre_id, presence: true
  
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :most_liked, -> { includes(:liked_users).sort_by { |x| x.liked_users.includes(:likes).size }.reverse }

  attr_accessor :new_genre_name
  
  def self.search_for(keyword)
    Post.where('title LIKE ? OR introduction LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end
  
  # 通知作成
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: "comment"
    )
    
    if notification.visited_id == current_user.id
      notification.is_checked = true
    end
    
    notification.save if notification.valid?
  end
end
