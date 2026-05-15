class ProjectDocumentsController < DocumentsController
  before_action :set_document, except: %i[ index create ]
  before_action :set_documentable

  def index
    render "projects/documents/index"
  end

  protected

  def partial_id
    "project-#{@project.id}-documents"
  end

  def partial_view
    "projects/documents/index"
  end

  private

  def set_documentable
    @project = @document ? @document.documentable : Project.find(params[:project_id]) if params[:project_id]
    @documentable = @project
  end

  def set_document
    @document = Document.find(params[:id])
  end
end
