class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :activities, as: :trackable

  validates :body, presence: true

  after_create :record_creation

  private

    def record_creation
      activities.create!(user: user, action: "create")
    end
end
