class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :activities, as: :trackable

  validates :body, presence: true
end
