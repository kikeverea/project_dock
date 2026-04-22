class Client < ApplicationRecord
  include Discard::Model
  include Phoneable
  include Emailable

  has_many :projects, dependent: :destroy
  has_many :activities, through: :projects
  has_many :tasks, through: :activities
  has_many :interactions, through: :tasks

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[ name primary_email email_addresses created_at ]
  end

  def active?
    activities.where.not(phase: [:closed_won, :closed_lost]).any?
  end

  def current_activity
    activities.order(:created_at).last
  end
end