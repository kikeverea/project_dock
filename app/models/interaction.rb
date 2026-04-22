class Interaction < ApplicationRecord

  belongs_to :user
  belongs_to :task
  belongs_to :parent_interaction, optional: true, class_name: "Interaction"
  has_many :replies, class_name: "Interaction", foreign_key: "parent_interaction_id"

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
