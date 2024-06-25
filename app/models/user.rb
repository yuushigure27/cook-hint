class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_one_attached :profile_image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'user_id'

  validates :email, presence: true, uniqueness: true
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 100 }

  #通知機能
   has_many :notifications, dependent: :destroy
   
  def active_notifications
    self.notifications.where(read: false) # 未読の通知を取得する例
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.png'
  end
  
  
  def self.search_for(keyword)
    User.where("name LIKE ?", "%#{keyword}%")
  end
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest User"
    end
  end

  GUEST_USER_EMAIL = 'guest@example.com'.freeze
  
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  def active_for_authentication?
    super && (is_active == true)
  end
end
