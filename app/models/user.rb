class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_one_attached :profile_image
  
  validates :email, presence: true, uniqueness: true
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  def introduction
    # ユーザーの自己紹介を返すロジックを実装する
    # 例えば、self.descriptionやself.bioなど
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.png'
  end
end
