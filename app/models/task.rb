class Task < ApplicationRecord
  include Documentable

  belongs_to :activity

  validates :title, presence: true

  enum :status, {
    pending: "pending",
    completed: "completed",
  },
  default: "pending"

end
