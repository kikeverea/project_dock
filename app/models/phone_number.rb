class PhoneNumber < ApplicationRecord
  belongs_to :phoneable, polymorphic: true

  def number
    format_number(super)
  end

  def number=(number)
    super(number.gsub(/\s+/, ''))
  end


  private

  def format_number(number)
    return "" if number.nil?
    number.chars.each_slice(3).map(&:join).join(' ')
  end
end
