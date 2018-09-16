require 'time'

class InvoiceItem
  attr_reader :item_id,
              :invoice_id,
              :created_at

  attr_accessor :quantity,
                :updated_at,
                :id,
                :unit_price

  def initialize(attributes)
    @id = attributes[:id]
    @item_id = attributes[:item_id]
    @invoice_id =attributes[:invoice_id].to_i
    @quantity = attributes[:quantity]
    @unit_price = BigDecimal(attributes[:unit_price]) / 100
    @created_at = Time.parse((attributes[:created_at]).to_s)
    @updated_at = Time.parse((attributes[:updated_at]).to_s)
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def create_id(new_id)
    @id = new_id.to_i
  end

end
