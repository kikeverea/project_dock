module Documentable
  extend ActiveSupport::Concern

  included do
    has_many :documents, as: :documentable, dependent: :destroy

    accepts_nested_attributes_for :documents, allow_destroy: true
  end
end