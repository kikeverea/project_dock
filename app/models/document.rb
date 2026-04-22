class Document < ApplicationRecord
  before_save :set_name
  before_validation :set_uploaded_by

  belongs_to :uploaded_by, class_name: "User"
  belongs_to :documentable, polymorphic: true

  mount_uploader :file, DocumentUploader

  def self.ransackable_associations(_auth_object = nil)
    %w[ ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ name created_at ]
  end

  def file_extension
    File.extname(file.identifier)&.delete('.')
  end


  private

  def set_name
    return if name.present?
    self.name = file.filename
  end

  def set_uploaded_by
    self.uploaded_by ||= Current.user
  end
end
