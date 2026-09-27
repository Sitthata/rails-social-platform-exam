class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  validates :action, inclusion: { in: %w[create] }
end
