class ProjectsController < ApplicationController
  before_action :set_project, except: %i[ index create ]
  before_action :set_clients, only: %i[ new edit create update ]

  def index
    @projects = Project.includes(activities: { tasks: :comments }).order(created_at: :desc)
  end

  def show
  end

  def new
    @project = Project.new(client_id: params[:client_id])

    render "components/turbo_modal_content", locals: { channel: :project, partial: "projects/form" }
  end

  def edit
  end

  def config_attr
    render "components/turbo_modal_content", locals: {
      channel: :config,
      partial: "projects/config/#{params[:config_attr]}_form"
    }
  end


  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to request.referrer, notice: "Proyecto creado"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Proyecto actualizado"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy!
    redirect_to projects_path, status: :see_other, notice: "Proyecto eliminado"
  end


  private

  def set_project
    @project = Project.find(params.expect(:id))
  end

  def set_clients
    @clients = Client.kept.order(:name)
  end

  def project_params
    params.expect(project: [
      :name,
      :client_id,
      :allocated_time,
      :used_time,
      :project_scope,
      :erd_url,
      :due_date,
      :start_date,
      project_scope_attributes: [
        :id,
        :file,
        :_destroy
      ]
    ])
  end
end
