class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :activities, as: :trackable

  validates :title, :body, presence: true
end
