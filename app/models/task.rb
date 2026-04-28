class Task < ApplicationRecord
  include Discard::Model
  include Documentable

  before_create :set_order

  belongs_to :activity

  validates :title, :activity_id, presence: true

  enum :status, {
    pending: "pending",
    completed: "completed",
  },
  default: "pending"


  private

  def set_order
    return if order.present?
    tasks = activity.tasks

    self.order ||= tasks.empty? ? 0 : tasks.count + 1
  end
end
