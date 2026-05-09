class TaskDocumentsController < DocumentsController
  before_action :set_documentable
  before_action :set_document, except: %i[ create ]

  protected

  def partial_id
    "task-#{@task.id}-documents"
  end

  def partial
    "tasks/documents"
  end

  def permitted_params
    [:task_id]
  end

  private

  def set_documentable
    @task = @document ? @document.documentable : Task.find(params[:task_id]) if params[:task_id]
    @documentable = @task
  end

  def set_document
    @document = Document.find(params[:id])
  end
end
