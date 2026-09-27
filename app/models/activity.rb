class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  validates :action, inclusion: { in: %w[create] }

  scope :newest_first, -> { order(created_at: :desc, id: :desc) }

  def self.for_post(post)
    where(trackable: post).or(
      where(trackable_type: "Comment", trackable_id: post.comments.select(:id))
    )
  end
end
