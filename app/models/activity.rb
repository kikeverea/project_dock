class Activity < WorkUnit
  after_create :batch_create_tasks

  attr_accessor :raw_tasks
  has_many :tasks, class_name: "Task", foreign_key: :parent_unit_id

  def tasks_completed?(tasks = self.tasks)
    tasks.any? && tasks.all? { |task| task.completed? }
  end

  private

  def batch_create_tasks
    return unless raw_tasks.is_a?(String) && raw_tasks.present?

    raw_tasks.lines.each do |line|
      next if line.blank?
      self.tasks << Task.new(activity: self, project_id: project_id, title: line)
    end
  end
end