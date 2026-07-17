class ActivityTasksController < ApplicationController
  before_action :set_activity
  before_action :set_task, except: %i[ index new create batch ]

  def index
    @tasks = Task.includes(task_comments: { replies: :parent_comment })
  end

  def show
  end

  def new
    @task = @activity.tasks.new
    refresh_task_form
  end

  def edit
    refresh_task_form(edit: true)
  end

  def create
    @task = @activity.tasks.new(task_params)

    if @task.save
      refresh_activity(message: "Tarea creada")
    else
      refresh_task_form
    end
  end

  def batch
    batch_params = params.dig(:task, :batch)

    if batch_params
      @task.batch_create_tasks(batch_params)
      refresh_activity(message: "Tareas creadas")
    else
      @task.errors.add(:batch, "campo obligatorio")
      refresh_task_form
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Tarea actualizada" }
        format.turbo_stream { refresh_activity(message: "Tarea actualizada") }
      else
        format.html { redirect_to @task, status: :unprocessable_content }
        format.turbo_stream { refresh_task_form }
      end
    end
  end

  def destroy
    @task.destroy!
    refresh_activity(message: "Tarea eliminada")
  end


  private

  def refresh_task_form(edit: false)
    render "components/turbo_modal_content",
      locals: { channel: :task, partial: "tasks/form", partial_locals: { edit: edit }}
  end

  def refresh_activity(message: nil)
    render turbo_stream: [
      turbo_stream.replace("activity-#{@task.id}", partial: "activities/activity"),
      turbo_stream.replace(
        "turbo-consumer",
        partial: "components/turbo_modal_action",
        locals: { channel: :task, action: :hide }
      ),
      (turbo_stream.replace(
        "turbo-message-consumer",
        partial: "components/turbo_message",
        locals: { message: message }
      ) if message.present?),
    ].compact
  end

  def set_task
    @task = Task.find(params.expect(:id))
  end

  def set_activity
    @task = Activity.find(params[:activity_id])
  end

  def task_params
    params.expect(task: [:title, :date, :activity_id, :status])
  end
end
