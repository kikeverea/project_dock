class RevokedController < ApplicationController

  layout "revoked"

  def revoked
    render plain: "Debes tener un rol asignado para acceder. Contacta con tu administrador.", layout: "revoked"
  end
end