class Comment < WorkUnit
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_unit_id, optional: true
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_unit_id
end