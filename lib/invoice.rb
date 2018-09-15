require 'time'

class Invoice

  attr_reader :id,
              :customer_id,
              :created_at,
              :merchant_id
attr_accessor :status,
              :updated_at
  def initialize(item_hash, created_at=Time.now, updated_at=Time.now)
    @id = item_hash[:id].to_i
    @customer_id = item_hash[:customer_id].to_i
    @merchant_id = item_hash[:merchant_id].to_i
    @status = item_hash[:status]
    @created_at = Time.parse((item_hash[:created_at].to_s))
    @updated_at = Time.parse((item_hash[:updated_at].to_s))
  end

  def create_id(new_id)
    @id = new_id
  end

end
