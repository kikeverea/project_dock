class Activity < WorkUnit
  has_many :tasks, class_name: "Task", foreign_key: :parent_unit_id

  def tasks_completed?(tasks = self.tasks)
    tasks.any? && tasks.all? { |task| task.completed? }
  end

  def batch_create_tasks(batch)
    batch.lines.each do |line|
      next if line.blank?

      self.tasks << Task.new(work_unit: self, title: line)
    end

    save
  end
end