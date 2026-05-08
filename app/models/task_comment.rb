class TaskComment < ApplicationRecord

  belongs_to :user
  belongs_to :task
  belongs_to :parent_comment, optional: true, class_name: "TaskComment"
  has_many :replies, class_name: "TaskComment", foreign_key: "parent_comment_id", dependent: :destroy

  validates :user_id, :task_id, :content, presence: true

  enum :status, {
    pending: "pending",
    seen: "seen",
    replied: "replied",
  },
  default: "pending"

  def status_text
    I18n.t("activerecord.enums.interaction.status.#{status}")
  end
end
