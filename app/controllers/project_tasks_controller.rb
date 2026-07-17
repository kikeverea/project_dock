class ProjectTasksController < ApplicationController
  before_action :set_project
  before_action :set_task, except: %i[ index new create ]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
    render "components/turbo_modal_content", locals: { channel: :task, partial: "tasks/form" }
  end

  def edit
  end

  def show
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      redirect_to request.referrer, notice: "Tarea creada"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @task.update(project_params)
      redirect_to @project, notice: "Tarea actualizada"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!
    redirect_to projects_path, status: :see_other, notice: "Tarea eliminada"
  end


  private

  def set_project
    @project = Project.find(params.expect(:project_id))
  end

  def set_task
    @project = Task.find(params.expect(:id))
  end

  def task_params
    params.expect(task: [
      :title,
      :content,
      :project_id,
      :acknowledged_at,
      :completed_at,
      :parent_task_id,
    ])
  end
end
