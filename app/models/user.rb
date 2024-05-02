class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
