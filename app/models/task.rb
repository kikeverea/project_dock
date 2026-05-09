class Task < ApplicationRecord
  include Discard::Model
  include Documentable

  before_create :set_order

  belongs_to :activity
  has_many :comments, class_name: "TaskComment",  dependent: :destroy

  validates :title, :activity_id, presence: true

  enum :status, {
    pending: "pending",
    completed: "completed",
  },
  default: "pending"

  def status_text
    I18n.t("activerecord.enums.task.status.#{status}")
  end

  def root_comments
    comments.where(parent_comment_id: nil)
  end


  private

  def set_order
    return if order.present?
    tasks = activity.tasks

    self.order ||= tasks.empty? ? 0 : tasks.count + 1
  end
end
