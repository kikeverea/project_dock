class Project < ApplicationRecord
  include Documentable

  belongs_to :client

  has_one :project_scope, -> { where(document_type: :project_scope) }, as: :documentable, class_name: "Document", dependent: :destroy
  accepts_nested_attributes_for :project_scope, allow_destroy: true

  has_many :work_units, dependent: :destroy
  has_many :tasks, class_name: "Task", foreign_key: :project_id, dependent: :destroy
  has_many :activities, class_name: "Activity", foreign_key: :project_id, dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: :project_id, dependent: :destroy

  validates :client_id, :name, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[ client ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ name created_at ]
  end

  def open_activities
    activities.where(completed_at: nil)
  end

  def pending_tasks
    tasks.where(completed_at: nil)
  end
end
