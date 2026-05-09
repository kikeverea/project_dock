class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process resize_to_fill: [160, 160]
  end

  def image?(file)
    file.content_type&.start_with?("image/")
  end
end
