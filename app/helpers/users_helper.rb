module UsersHelper
  def role_text(role)
    I18n.t("activerecord.enums.user.role.#{role}")
  end
end
