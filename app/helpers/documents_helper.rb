module DocumentsHelper
  def file_name(file, tiny=false)
    file_extension = File.extname(file.file_identifier)
    name = file.file_identifier.gsub(file_extension, "")

    tiny ?
      "#{name.first(15)}..." :
      name
  end

  def get_document_icon(document)
    get_document_icon_by_type(document.file.content_type)
  end

  def get_document_icon_by_type(type)
    type = type.downcase

    is_pdf = type.include?("pdf")
    is_excel = type.include?("excel") || type.include?("csv") || type.include?("sheet")
    is_power_point = type.include?("ppt") || type.include?("presentation")
    is_image = type.include?("image")
    is_doc = type.include?("document")

    if is_pdf
      %w[file-pdf danger]

    elsif is_excel
      %w[file-excel success]

    elsif is_power_point
      %w[file-powerpoint orange]

    elsif is_doc
      %w[file-word primary]

    elsif is_image
      %w[file-image info]
    else
      %w[file gray-700]
    end
  end
end