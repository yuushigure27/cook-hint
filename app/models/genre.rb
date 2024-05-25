class Genre < ApplicationRecord
  has_many :posts

  validates :name, presence: true, uniqueness: true, length: { maximum: 15 }
end
