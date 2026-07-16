class ActivitiesController < ApplicationController
  before_action :set_project
  before_action :set_activity, except: %i[ index new create ]

  def index
    @work_units = WorkUnit.all
  end

  def show
  end

  def generating_interaction
    render "components/turbo_modal_content", locals: {
      channel: :interaction,
      content: @work_unit.generating_interaction&.html_safe || "",
    }
  end

  def new
    @work_unit = WorkUnit.new

    refresh_activity_form
  end

  def edit
    refresh_activity_form
  end

  def create
    @work_unit = WorkUnit.new(activity_params)

    if @work_unit.save
      redirect_to @project, notice: "Actividad creada"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @work_unit.update(activity_params)
      redirect_to @project, notice: "Actividad actualizada"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @work_unit.destroy!
    redirect_to @project, status: :see_other, notice: "Actividad eliminada"
  end


  private

  def refresh_activity_form
    render "components/turbo_modal_content", locals: { channel: :work_unit, partial: "activities/form" }
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end

  def set_activity
    activity_id = params[:id] || params[:activity_id]
    @work_unit = WorkUnit.find(activity_id)
    @project ||= @work_unit.project
  end

  def activity_params
    params.expect(work_unit: [:name, :date, :project_id])
  end
end
