require 'time'

class Invoice

  attr_reader :id,
              :customer_id,
              :created_at,
              :merchant_id

attr_accessor :status,
              :updated_at

  def initialize(attributes)
    @id = attributes[:id].to_i
    @customer_id = attributes[:customer_id]
    @merchant_id = attributes[:merchant_id]
    @status = attributes[:status]
    @created_at = Time.parse(attributes[:created_at].to_s)
    @updated_at = Time.parse(attributes[:updated_at].to_s)
  end

  def create_id(new_id)
    @id = new_id
  end

  def day
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    day_of_week = @created_at.wday
    days[day_of_week]
  end

  def created_at_date
    [@created_at.year, @created_at.month, @created_at.day]
  end

end
