require 'time'
class Transaction

  attr_reader :id,
              :invoice_id,
              :created_at

  attr_accessor :result,
                :credit_card_number,
                :credit_card_expiration_date,
                :updated_at

  def initialize(attributes)
    @id = attributes[:id]
    @result = attributes[:result].to_sym
    @credit_card_number = attributes[:credit_card_number]
    @invoice_id = attributes[:invoice_id].to_i
    @credit_card_expiration_date = attributes[:credit_card_expiration_date]
    @created_at = Time.parse(attributes[:created_at].to_s)
    @updated_at = Time.parse(attributes[:updated_at].to_s)
  end

  def change_updated_at
    time = Time.now
    updated_at = Time.parse(Time.now)
  end

  def last_updated_date
    string = @updated_at.to_s.split(" ")[0]
    Time.parse(string)
  end
  
end
