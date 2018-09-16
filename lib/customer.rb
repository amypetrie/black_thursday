class Customer
  attr_accessor :first_name,
                :last_name,
                :id,
                :created_at,
                :updated_at

  def initialize(attributes)
    @id = attributes[:id]
    @first_name = attributes[:first_name].capitalize
    @last_name =attributes[:last_name].capitalize
    @created_at = Time.parse((attributes[:created_at]).to_s)
    @updated_at = Time.parse((attributes[:updated_at]).to_s)
  end

end
