class TasksController < ApplicationController
  before_action :set_activity
  before_action :set_project
  before_action :set_task, except: %i[ index new create ]

  def index
    @tasks = Task.where(created_by: Current.user)
  end

  def new
    @task = new_task
    show_form
  end

  def edit
    show_form
  end

  def show
  end

  def create
    @task = new_task(task_params)

    if @task.save!
      refresh_task_container
    else
      refresh_form
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to @task, notice: "Tarea actualizada" }
        format.turbo_stream { refresh_task_container }
        format.json { head :ok }
      end
    else
      refresh_form
    end
  end

  def destroy
    @task.destroy!
    refresh_task_container
  end


  private

  def new_task(params={})
    if @activity
      @activity.tasks.new(params)
    elsif @project
      @project.tasks.new(params)
    else
      Task.new
    end
  end

  def show_form
    render "components/turbo_modal_content", locals: { channel: :task, partial: "tasks/form" }
  end

  def refresh_form
    render turbo_stream: turbo_stream.replace("task-form", partial: "tasks/form")
  end

  def refresh_task_container
    render "components/turbo_modal_content", locals: {
      channel: :task,
      partial: "tasks/form",
      action: :hide,
      replace: target_container
    }
  end

  def target_container
    @activity ?
      { target: "activity-#{@activity.id}", partial: "activities/activity" } :
      { target: "work-units", partial: "projects/work_units" }
  end

  def set_task
    @task = Task.find(params.expect(:id))
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def set_activity
    @activity = Activity.find(params[:activity_id]) if params[:activity_id].present?
  end

  def task_params
    params.expect(task: [
      :title,
      :content,
      :acknowledged_at,
      :completed_at,
      :completed_by_id,
      :parent_task_id,
    ])
  end
end
