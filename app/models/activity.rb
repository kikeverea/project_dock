class Activity < ApplicationRecord
  before_validation :set_name
  before_validation :set_date
  before_validation :set_order

  belongs_to :project
  belongs_to :proposed_by, class_name: "User", optional: true

  has_many :tasks, dependent: :destroy
  has_many :interactions, through: :tasks

  validates :project_id, :name, :date, :order, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[ project ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ name date created_at ]
  end

  def date=(date)
    super(date.presence || Time.current)
  end


  private

  def set_name
    return if persisted? || name.present?
    self.name = "Actividad #{(self.date.presence || Time.current).strftime("%d-%m-%Y")}"
  end

  def set_date
    return if persisted? || date.present?
    self.date = Time.current
  end

  def set_order
    return if persisted? || order.present?
    activities = project.activities

    self.order = activities.empty? ? 0 : activities.count + 1
  end
end
