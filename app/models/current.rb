class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :ability
  attribute :client

  delegate :user, to: :session, allow_nil: true
end
