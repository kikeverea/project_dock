class TmpImageUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    "uploads/tmp/"
  end
end