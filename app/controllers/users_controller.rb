class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    authorize! :read, User

    @search = params[:q].present? ? params[:q][:email_or_name_cont] : ""

    @q = User.accessible_by(current_ability).ransack(params[:q])
    @users = @q.result.order("users.name DESC").paginate(page: params[:page], per_page: 15)
  end

  def show
    authorize! :read, @user
    @projects = @user.projects.paginate(page: params[:page], per_page: 15)
  end

  def new
    authorize! :create, User

    @user = User.new
  end

  def edit
    authorize! :update, @user
  end

  def profile
    @user = current_user
    @projects = @user.projects
    render :show
  end

  def create
    authorize! :create, User

    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "Usuario creado"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize! :update, @user

    if @user.update(user_params)
      redirect_to users_path, notice: "Usuario actualizado"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.destroy
    redirect_to users_path, notice: "Usuario eliminado"
  end

  def logout
    terminate_session
    redirect_to new_session_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    parameters = params
      .require(:user)
      .permit(
        :role,
        :name,
        :lastname,
        :email,
        :password,
        :password_confirmation,
        :image
      )

    parameters[:password].present? ?
      parameters :
      parameters.except(:password, :password_confirmation)
  end
end
