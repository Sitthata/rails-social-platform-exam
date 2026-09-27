class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :activities, as: :trackable

  validates :title, :body, presence: true

  after_create :record_creation
  before_destroy :record_deletion, prepend: true

  private

    def record_creation
      activities.create!(user: user, action: "create")
    end

    def record_deletion
      activities.create!(user: user, action: "delete")
    end
end
