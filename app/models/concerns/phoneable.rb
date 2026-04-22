module Phoneable
  extend ActiveSupport::Concern

  included do
    has_many :phone_numbers, as: :phoneable, dependent: :destroy
    accepts_nested_attributes_for :phone_numbers, allow_destroy: true

    ransacker :phones do
      Arel.sql(
        "(SELECT GROUP_CONCAT(phone_numbers.number SEPARATOR ', ')
            FROM phone_numbers
            WHERE phone_numbers.phoneable_id = #{self.table_name}.id
              AND phone_numbers.phoneable_type = '#{self.name}')"
      )
    end
  end
end