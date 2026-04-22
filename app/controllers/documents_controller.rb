class DocumentsController < ApplicationController

  def index
    @show_archived = params[:show_archived] == "true"

    @query = Document.ransack(params[:q])

    @documents = @query
      .result
      .accessible_by(current_ability, :read)
      .order("created_at DESC")
      .paginate(page: params[:page] || 1, per_page: params[:per_page] || 15)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "documents-table",
          partial: "documents/table",
          locals: {
            documents: @documents,
            show_trip: true,
            show_associated: true,
            is_admin: true,
            delete_path: -> document { destroy_document_path(document) }
          })
      }
      format.html
    end
  end

  def create
    model = params[:documentable_type].constantize

    document = Document.new(
      file: params[:file],
      name: params[:name],
      uploaded_by: current_user,
      documentable_id: params[:documentable_id],
      documentable_type: params[:documentable_type]
    )

    documentable = document.documentable.becomes(model) # Forces base classes in STI

    if document.save
      render turbo_stream: [
        turbo_stream.replace("documents-index", partial: "documents/documents", locals: { documentable: documentable }),
        turbo_stream.replace("turbo-consumer", partial: "components/turbo_message", locals: { message: "Documento subido" }),
      ]
    else
      toast("No se ha podido subir el documento", :error)
    end
  end

  def destroy
    model = params[:documentable_type].constantize
    document = Document.find(params[:id])

    documentable = document.documentable.becomes(model) # Forces base classes in STI

    if document.destroy
      render turbo_stream: [
        turbo_stream.replace("documents-index", partial: "documents/documents", locals: { documentable: documentable }),
        turbo_stream.replace("turbo-consumer", partial: "components/turbo_message", locals: { message: "Documento eliminado" }),
      ]
    else
      toast("Error al eliminar el documento", :error)
    end
  end


  private

  def document_params
    params.permit(:name, :file, :documentable_id, :documentable_type)
  end
end