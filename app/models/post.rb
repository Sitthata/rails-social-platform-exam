class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :activities, as: :trackable

  validates :title, :body, presence: true

  after_create :record_creation

  private

    def record_creation
      activities.create!(user: user, action: "create")
    end
end
