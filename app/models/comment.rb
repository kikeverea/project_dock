class Comment < WorkUnit
  scope_self_reference

  belongs_to :activity, foreign_key: :parent_unit_id, optional: true
  belongs_to :task, foreign_key: :parent_unit_id, optional: true
end