class Task < WorkUnit
  scope_self_reference
  im_completable

  belongs_to :activity, foreign_key: :parent_unit_id, optional: true
  has_many :comments, foreign_key: :parent_unit_id

  alias_method :sub_tasks, :child_tasks
end