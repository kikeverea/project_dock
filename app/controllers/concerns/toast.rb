module Toast
  extend ActiveSupport::Concern

  def toast(message, type="success")
    render "components/message", locals: { message: message, type: type.to_s }
  end
end