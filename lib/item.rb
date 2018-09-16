class Item

  attr_reader :id,
              :merchant_id,
              :created_at

  attr_accessor :updated_at,
                :name,
                :description,
                :unit_price

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @description = attributes[:description]
    @unit_price = BigDecimal(attributes[:unit_price]) / 100
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
    @merchant_id = attributes[:merchant_id]
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def create_id(new_id)
    @id = new_id.to_i
  end

  def price
    @unit_price.to_f
  end

end
