class TasksController < ApplicationController
  before_action :set_project
  before_action :set_activity
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new

    refresh_task_form
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @project, notice: "Tarea creada"
    else
      refresh_task_form
    end
  end

  def batch
    batch_params = params.dig(:activity, :batch)

    if batch_params
      @activity.batch_create_tasks(batch_params)
      redirect_to @project, notice: "Tareas creadas"
    else
      @activity.errors.add(:batch, "campo obligatorio")
      refresh_task_form
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @project, notice: "Tarea actualizada"
    else
      refresh_task_form
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_path, status: :see_other, notice: "Tarea eliminada"
  end


  private

  def refresh_task_form
    render "components/turbo_modal_content", locals: { channel: :task, partial: "tasks/form" }
  end

  def set_task
    @task = Task.find(params.expect(:id))
  end

  def set_activity
    @activity = Activity.find(params.expect(:activity_id))
  end

  def set_project
    @project = Project.find(params.expect(:project_id))
  end

  def task_params
    params.expect(task: [:title, :date, :activity_id, :status])
  end
end
