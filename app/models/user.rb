class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :activities

  devise :database_authenticatable, :rememberable, :validatable
end
