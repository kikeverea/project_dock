class Activity < ApplicationRecord
  before_save :set_date, on: :create

  belongs_to :project
  belongs_to :proposed_by, class_name: "User", optional: true

  has_many :tasks, dependent: :destroy
  has_many :interactions, through: :tasks

  validates :project_id, :client_id, presence: true
  validates :number, uniqueness: true

  def self.ransackable_associations(_auth_object = nil)
    %w[ client ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ number name phase total client_id created_at ]
  end

  ransacker :total do |parent|
    projects = Project.arel_table

    subquery =
      projects
        .project(projects[:total].sum)
        .where(projects[:activity_id].eq(parent.table[:id]))

    Arel.sql("COALESCE((#{subquery.to_sql}), 0)")
  end


  private

  def set_date
    date ||= created_at
  end
end
