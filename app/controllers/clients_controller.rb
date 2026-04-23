class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]

  def index
    @clients = Client.all
  end

  def show
  end

  def new
    @client = Client.new

    respond_to do |format|
      format.html { render :new }
      format.turbo_stream do
        render "components/turbo_modal_content", locals: { channel: :client, partial: "clients/form" }
      end
    end
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: "Cliente creado"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Cliente actualizado"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @client.destroy!
    redirect_to clients_path, status: :see_other, notice: "Cliente eliminado"
  end


  private

  def set_client
    @client = Client.find(params.expect(:id))
  end

  def client_params
    params.expect(client:[
      :name,
      :logo,
      emails_attributes: [],
      phone_numbers_attributes: []]
    )
  end
end
