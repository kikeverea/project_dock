class PhoneNumbersController < ApplicationController
  before_action :set_phone_number, only: %i[ show edit update destroy ]

  def index
    @phone_numbers = PhoneNumber.all
  end

  def show
  end

  def new
    @phone_number = PhoneNumber.new
  end

  def edit
  end

  def create
    @phone_number = PhoneNumber.new(phone_number_params)

    if @phone_number.save
      redirect_to @phone_number, notice: "Phone number was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @phone_number.update(phone_number_params)
      redirect_to @phone_number, notice: "Phone number was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @phone_number.destroy!
    redirect_to phone_numbers_path, status: :see_other, notice: "Phone number was successfully destroyed."
  end


  private

  def set_phone_number
    @phone_number = PhoneNumber.find(params.expect(:id))
  end

  def phone_number_params
    params.fetch(:phone_number, {})
  end
end
