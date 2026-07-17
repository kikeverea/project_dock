class TasksController < ApplicationController
  before_action :set_task, except: %i[ index new create ]

  def index
    @tasks = Task.where(created_by: Current.user)
  end

  def new
    @task = Tasks.new
    show_form
  end

  def edit
    show_form
  end

  def show
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to request.referrer, notice: "Tarea creada"
    else
      refresh_form
    end
  end

  def update
    if @task.update!(task_params)
      refresh_task
    else
      refresh_form
    end
  end

  def destroy
    @task.destroy!
    render turbo_stream: turbo_stream.remove("task-#{@task.id}")
  end


  private

  def show_form
    render "components/turbo_modal_content", locals: { channel: :task, partial: "tasks/form" }
  end

  def refresh_form
    render turbo_stream: turbo_stream.replace("task-form", partial: "tasks/form")
  end

  def refresh_task
    render "components/turbo_modal_content", locals: {
      channel: :task,
      partial: "tasks/form",
      action: :hide,
      replace: { target: "task-#{@task.id}", partial: "tasks/task" }
    }
  end

  def set_task
    @task = Task.find(params.expect(:id))
  end

  def task_params
    params.expect(task: [
      :title,
      :status,
      :content,
      :project_id,
      :acknowledged_at,
      :completed_at,
      :completed_by_id,
      :parent_task_id,
    ])
  end
end
