class DocumentsController < ApplicationController
  include Toast

  def create
    document = Document.new(document_params)
    document.documentable = @documentable

    if document.save!
      render turbo_stream: [
        turbo_stream.replace(partial_id, partial: partial),
        turbo_stream.replace("turbo-message-consumer", partial: "components/turbo_message", locals: { message: "Documento subido" }),
      ]
    else
      toast("Error al subir el documento", :error)
    end
  end

  def destroy
    document = Document.find(params[:id])

    if document.destroy
      render turbo_stream: [
        turbo_stream.replace(partial_id, partial: partial),
        turbo_stream.replace("turbo-message-consumer", partial: "components/turbo_message", locals: { message: "Documento eliminado" }),
      ]
    else
      toast("Error al eliminar el documento", :error)
    end
  end


  private

  def document_params
    params.expect(document: [:name, :file])
  end
end