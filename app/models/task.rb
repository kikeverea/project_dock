class Task < WorkUnit
  belongs_to :activity, class_name: "Activity", foreign_key: :parent_unit_id, optional: true
  has_many :sub_tasks, class_name: "Task", foreign_key: :parent_unit_id
end