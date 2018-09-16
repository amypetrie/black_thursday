class Transaction

  attr_reader :id,
              :result,
              :credit_card_number,
              :invoice_id,
              :credit_card_expiration_date,
              :created_at,
              :updated_at

  def initialize(attributes)
    @id = attributes[:id]
    @result = attributes[:result]
    @credit_card_number = attributes[:credit_card_number]
    @invoice_id = attributes[:invoice_id]
    @credit_card_expiration_date = attributes[:credit_card_expiration_date]
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end

end
