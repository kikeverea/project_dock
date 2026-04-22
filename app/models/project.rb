class Project < ApplicationRecord
  include Documentable

  belongs_to :client

  has_many :activities, dependent: :destroy
  has_many :tasks, through: :activities
  has_many :interactions, through: :activities

  validates :client_id, :name, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[ client ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ name created_at ]
  end
end
