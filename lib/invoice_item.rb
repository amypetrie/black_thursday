require 'time'

class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(attributes)
    @id = attributes[:id]
    @item_id = attributes[:item_id]
    @invoice_id =attributes[:invoice_id]
    @quantity = attributes[:quantity]
    @unit_price = attributes[:unit_price]
    @created_at = Time.parse((attributes[:created_at]).to_s)
    @updated_at = Time.parse((attributes[:updated_at]).to_s)
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
