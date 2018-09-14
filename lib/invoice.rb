require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/item'
require_relative '../lib/item_repo'
require_relative '../lib/invoice_repo'

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
