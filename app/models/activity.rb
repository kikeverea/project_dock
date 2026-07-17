class Activity < WorkUnit
  im_completable

  after_create :batch_create_tasks, if: -> { self.raw_tasks.present? }

  attr_accessor :raw_tasks

  has_many :tasks, foreign_key: :parent_unit_id, dependent: :destroy
  has_many :comments, foreign_key: :parent_unit_id, dependent: :destroy

  def tasks_completed?(tasks = self.tasks)
    tasks.any? && tasks.all? { |task| task.completed? }
  end

  private

  def batch_create_tasks
    return unless raw_tasks.is_a?(String)

    raw_tasks.lines.each do |line|
      next if line.blank?
      self.tasks << Task.new(activity: self, project_id: project_id, title: line)
    end
  end
end