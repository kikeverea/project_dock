module WorkUnitController
  extend ActiveSupport::Concern

  def refresh_task
    render "components/turbo_modal_content", locals: {
      channel: :task,
      partial: "tasks/form",
      action: :hide,
      replace: { target: "task-#{@task.id}", partial: "tasks/task" }
    }
  end
end