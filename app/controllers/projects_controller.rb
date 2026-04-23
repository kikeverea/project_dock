class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_clients, only: %i[ new edit create update ]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy!
    redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed."
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
      :current_time,
      :due_date,
      :start_date,
    ])
  end
end
