class ActivitiesController < ApplicationController
  before_action :set_project
  before_action :set_activity, except: %i[ index new create ]

  def index
    @activities = Activity.all
  end

  def show
  end

  def new
    @activity = Activity.new

    refresh_activity_form
  end

  def edit
    refresh_activity_form
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save!
      redirect_to @project, notice: "Actividad creada"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to @project, notice: "Actividad actualizada"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @activity.destroy!
    redirect_to @project, status: :see_other, notice: "Actividad eliminada"
  end


  private

  def refresh_activity_form
    render "components/turbo_modal_content", locals: { channel: :activity, partial: "activities/form" }
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end

  def set_activity
    activity_id = params[:id] || params[:activity_id]
    @activity = Activity.find(activity_id)
    @project ||= @activity.project
  end

  def activity_params
    params.expect(activity: [:name, :date, :project_id, :raw_tasks])
  end
end
