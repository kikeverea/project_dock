class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  before_destroy :check_if_last_admin

  has_many :interactions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :projects, dependent: :destroy

  mount_base64_uploader :image, ImageUploader

  validates :email, :name, :lastname, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at full_name name lastname email role]
  end

  ransacker :full_name do
    Arel.sql("LOWER(CONCAT(users.name, ' ', users.lastname))")
  end

  enum :role, {
    administration: "administration",
    admin: "admin",
    technician: "technician"
  }

  def role_text
    I18n.t("activerecord.enums.user.role.#{self.role}")
  end

  def admin?
    role == "admin"
  end

  def full_name
    "#{self.name} #{self.lastname}"
  end

  def send_new_candidate_email(candidate, job_title)
    AdminMailer.send_new_candidate_email(self, candidate, job_title).deliver_later
  end

  private

  def check_if_last_admin
    if self.admin? && User.admin.count == 1
      errors.add(:base, "No se puede eliminar al administrador")
      throw(:abort)
    end
  end
end
