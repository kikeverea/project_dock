class Log < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  belongs_to :user

  enum :action, {
    created: "created",
    updated: "updated",
    destroyed: "destroyed",
  }

  def self.ransackable_associations(_auth_object = nil)
    %w[ user ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ description action user_id loggable_id loggable_type created_at ]
  end
end