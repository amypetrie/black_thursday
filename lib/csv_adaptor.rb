
require 'csv'
require 'time'

class CsvAdaptor

  def parse_merchants(data_file)
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:name] = obj[:name]
      obj[:created_at] = Time.parse(obj[:created_at])
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj.to_h
    end
  end

  def parse_items(data_file)
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:name] = obj[:name]
      obj[:created_at] = Time.parse(obj[:created_at])
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj[:description] = obj[:description]
      obj[:unit_price] = obj[:unit_price]
      obj[:merchant_id] = obj[:merchant_id].to_i
      obj.to_h
    end
  end

  def parse_invoices(data_file)
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:customer_id] = obj[:customer_id].to_i
      obj[:merchant_id] = obj[:merchant_id].to_i
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj[:status] = obj[:status].to_sym
      obj[:created_at] = Time.parse(obj[:created_at])
      obj.to_h
    end
  end

  def parse_invoice_items(data_file)
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:item_id] = obj[:item_id].to_i
      obj[:invoice_id] = obj[:invoice_id]
      obj[:quantity] = obj[:quantity]
      obj[:created_at] = Time.parse(obj[:created_at])
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj.to_h
    end
  end

  def parse_transactions(data_file)
    do_nothing if data_file == nil
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:result] = obj[:result].to_sym
      obj[:credit_card_number] = obj[:credit_card_number]
      obj[:invoice_id] = obj[:invoice_id]
      obj[:credit_card_expiration_date] = obj[:credit_card_expiration_date]
      obj[:created_at] = Time.parse(obj[:created_at])
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj.to_h
    end
  end

  def parse_customers(data_file)
    csv_objs = CSV.read(data_file, headers: true, header_converters: :symbol)
    csv_objs.map do |obj|
      obj[:id] = obj[:id].to_i
      obj[:first_name] = obj[:first_name].to_s.upcase
      obj[:last_name] = obj[:last_name].to_s.upcase
      obj[:created_at] = Time.parse(obj[:created_at])
      obj[:updated_at] = Time.parse(obj[:updated_at])
      obj.to_h
    end
  end

end
