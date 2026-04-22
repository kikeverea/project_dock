module Emailable
  extend ActiveSupport::Concern

  included do
    has_many :emails, as: :emailable, dependent: :destroy
    accepts_nested_attributes_for :emails, allow_destroy: true

    ransacker :email_addresses do
      Arel.sql(
        "(SELECT GROUP_CONCAT(emails.email SEPARATOR ', ')
            FROM emails
            WHERE emails.emailable_id = #{self.table_name}.id
              AND emails.emailable_type = '#{self.name}')"
      )
    end
  end

end