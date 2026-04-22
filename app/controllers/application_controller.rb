class ApplicationController < ActionController::Base
  include Authentication

  before_action :validate_role_presence
  before_action :set_current

  helper_method :current_user

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, notice: "No tienes permiso para realizar esta acción."
  end

  def current_user
    Current.user
  end

  def validate_role_presence
    return if request.path == revoked_path || request.path == new_session_path
    redirect_to revoked_path if current_user && !current_user.role.present?
  end

  def set_current
    Current.ability = current_ability
  end
end
