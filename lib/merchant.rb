
require 'time'

class Merchant

  attr_reader :id,
              :created_at,
              :updated_at

  attr_accessor :name

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end

  def create_id(new_id)
    @id = new_id
  end

  def change_name(name)
    @name = name
  end

  def change_updated_at
    time = Time.now
    @updated_at = Time.parse(time.to_s)
  end

end
