class Ability
  include CanCan::Ability
  def initialize(user)

    return if user.nil? || user.role.blank?

    if user.admin?
      can :manage, :all
      return
    end

    can :manage, Client, id: user.client_id
    can :manage, Task, client_id: user.client_id
    can :manage, Activity, client_id: user.client_id
    can [:create, :read], Interaction, client_id: user.client_id
    can [:update, :destroy], Interaction, user_id: user.id

    cannot :manage, User
    can :update, User, id: user.id
    can :read, User, client_id: user.client_id
  end
end
