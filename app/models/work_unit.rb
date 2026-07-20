class WorkUnit < ApplicationRecord
  include Discard::Model
  include ScopedWorkUnit

  before_validation :set_title
  before_validation :set_project
  before_validation :set_created_by

  belongs_to :project
  belongs_to :parent_unit, class_name: "WorkUnit", optional: true
  belongs_to :created_by, class_name: "User"
  belongs_to :completed_by, class_name: "User", optional: true

  has_many :comments, foreign_key: :parent_unit_id
  has_many :documents, as: :documentable
  has_many :logs, as: :loggable

  validates :project_id, :title, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[ project ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ title date created_at ]
  end

  def type_text
    I18n.t("activerecord.models.#{self.type.downcase}.one")
  end

  def acknowledged?
    acknowledged_at.present?
  end

  def completed?
    completed_at.present?
  end

  def status
    return :completed if completed_at?
    return :acknowledged if acknowledged_at?

    :new
  end

  private

  def set_title
    return if persisted? || title.present?
    self.title = "#{type_text} #{Time.current.strftime("%d-%m-%Y")}"
  end

  def set_project
    self.project ||= parent_unit&.project
  end

  def set_created_by
    self.created_by ||= Current.user
  end
end