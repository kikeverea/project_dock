class EmailsController < ApplicationController
  before_action :set_email, only: %i[ show edit update destroy ]

  def index
    @emails = Email.all
  end

  def show
  end

  def new
    @email = Email.new
  end

  def edit
  end

  def create
    @email = Email.new(email_params)

    if @email.save
      redirect_to @email, notice: "Email was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @email.update(email_params)
      redirect_to @email, notice: "Email was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @email.destroy!
    redirect_to emails_path, status: :see_other, notice: "Email was successfully destroyed."
  end

  private
    def set_email
      @email = Email.find(params.expect(:id))
    end

    def email_params
      params.fetch(:email, {})
    end
end
