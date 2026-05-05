class InteractionsController < ApplicationController
  include Toast

  before_action :set_task
  before_action :set_interaction, except: %i[ index new create ]

  def new
    refresh_activity(show_comments: true)
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("interaction-#{@interaction.id}",
        partial: "interactions/card",
        locals: { interaction: @interaction, edit: true, show_user: @from_user_profile ? "lead" : "creator" }
      )}
      format.html
    end
  end

  def cancel_edit
    render turbo_stream: turbo_stream.replace(
      "interaction-#{@interaction.id}",
      partial: "interactions/card",
      locals: { interaction: @interaction, show_user: @from_user_profile ? "lead" : "creator" }
    )
  end

  def create
    @interaction = Interaction.new(interaction_params)

    if @interaction.save
      redirect_to request.referrer, status: :see_other, notice: "Interaction was successfully created."
    else
      toast("La interacción no ha podido ser guardada", :error)
    end
  end

  def update
    if @interaction.update(update_params)
      render turbo_stream: turbo_stream.replace(
        "interaction-#{@interaction.id}",
        partial: "interactions/card",
        locals: { interaction: @interaction, show_user: @from_user_profile ? "lead" : "creator" }
      )
    else
      toast("No se ha podido actualizar la interacción", :error)
    end
  end

  def destroy
    if @interaction.destroy
      render turbo_stream: turbo_stream.remove("interaction-#{@interaction.id}")
    else
      toast("No se ha podido eliminar la interacción", :error)
    end
  end

  private

  def set_interaction
    @interaction = Interaction.find(params[:id])
    @task ||= @interaction.task
  end

  def set_task
    @task = Task.find(params[:task_id]) if params[:task_id]
  end

  def interaction_params
    interaction_params = params.require(:interaction).permit(:user_id, :lead_id, :activity_id, :status, :content)
    interaction_params[:user] = current_user
    interaction_params
  end

  def update_params
    params.require(:interaction).permit(:status, :content)
  end
end