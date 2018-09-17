require_relative '../lib/repo_methods'
require 'pry'

class SalesAnalyst < SalesEngine
  include RepoMethods

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

# item repo helper method
  def average_items_per_merchant
    (@sales_engine.items.all.count / @sales_engine.merchants.all.count.to_f).round(2)
  end

# item repo helper method
  def item_object_per_merchant
    @sales_engine.items.all.group_by do |item|
      item.merchant_id
    end
  end

#merchant repo helper method
  def all_merchant_ids
    @sales_engine.merchants.all.map do |merchant|
      merchant.id.to_s
    end
  end

# item repo helper method
  def number_of_items_per_merchant
    array = item_object_per_merchant.map do |merchant, items|
      items = items.count
    end
  end

#required
  def average_items_per_merchant_standard_deviation
    array = number_of_items_per_merchant
    average = average_items_per_merchant
    find_standard_deviation(array, average, "sample")
  end

#helper method
  def merchant_and_item_count_hash
    hash = Hash.new
    item_object_per_merchant.each do |id, item_array|
      hash[id] = item_array.length
    end
    hash
  end

#item repo helper method
  def find_merchant_ids_with_high_item_count
    hash = merchant_and_item_count_hash
    array = []
    hash.each do |id, item_count|
      if item_count > (average_items_per_merchant + average_items_per_merchant_standard_deviation)
        array << id
      else nil
      end
    end
    array
  end

#required method
  def merchants_with_high_item_count
    array = []
    find_merchant_ids_with_high_item_count.each do |id|
      @sales_engine.merchants.all.each do |merchant|
        if merchant.id == id.to_i
          array << merchant
        end
      end
    end
    array
  end

#required method
  def average_item_price_for_merchant(id)
    id = id.to_s
    merchant_items = @sales_engine.items.find_all_by_merchant_id(id)
    item_array = merchant_items.map do |item|
      item.unit_price
    end
    sum = item_array.reduce(0) do |sum, price|
      sum += price
      sum
    end
    avg = (sum / item_array.length)
    BigDecimal((sum / item_array.length)).round(2)
  end

#required method
  def average_average_price_per_merchant
    average_price_array = all_merchant_ids.map do |id|
      average_item_price_for_merchant(id)
    end
    sum = average_price_array.reduce(0) do |sum, price|
      sum += price
      sum
    end
    BigDecimal((sum / average_price_array.length)).round(2)
  end

  def average_item_price_array
    average_price_array = @sales_engine.items.all.map do |item|
      item.price
    end
  end

  def golden_items
    array = average_item_price_array
    average = array_average_value(array)
    standard_deviation = find_standard_deviation(array, average, "sample")
    golden_value = average + (standard_deviation * 2)
    @sales_engine.items.all.find_all do |item|
      item.price > golden_value
    end
  end

#iteration 2

#helper
  def invoice_object_per_merchant
    @sales_engine.invoices.all.group_by do |invoices|
      invoices.merchant_id
    end
  end

  def number_of_invoices_per_merchant
    array = invoice_object_per_merchant.map do |merchant, invoices|
      invoices = invoices.count
    end
  end
#required
  def average_invoices_per_merchant
    (@sales_engine.invoices.all.count / @sales_engine.merchants.all.count.to_f).round(2)
  end
#required
  def average_invoices_per_merchant_standard_deviation
      array = number_of_invoices_per_merchant
      average = average_invoices_per_merchant
      find_standard_deviation(array, average, "sample")
  end

#helper

  def merchant_and_invoice_count_hash
    hash = Hash.new
    invoice_object_per_merchant.each do |id, invoice_array|
      hash[id] = invoice_array.length
    end
    hash
  end
#helper
  def top_invoice_threshold
    average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)
  end

  def bottom_invoice_threshold
    average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
  end
#helper
  def merchant_ids_with_high_item_count(hash, number)
    id_array = find_high_value_counts_by_id(hash, number)
    merchants_with_high_value_count(id_array)
  end

  def top_merchants_by_invoice_count
    hash = merchant_and_invoice_count_hash
    number = top_invoice_threshold
    merchant_ids_with_high_item_count(hash, number)
  end

  def merchant_ids_with_low_item_count(hash, number)
    id_array = find_low_value_counts_by_id(hash, number)
    merchants_with_high_value_count(id_array)
  end

  def bottom_merchants_by_invoice_count
    hash = merchant_and_invoice_count_hash
    number = bottom_invoice_threshold
    merchant_ids_with_low_item_count(hash, number)
  end

  def average_invoices_per_day
    (@sales_engine.invoices.all.count / 7).round(2)
  end
#required
  def average_invoices_per_day_standard_deviation
      array = number_of_invoices_per_day
      average = average_invoices_per_day
      find_standard_deviation(array, average, "sample")
  end

  def top_days_by_invoice_count
    array = []
    hash = invoice_object_per_day
    number = average_invoices_per_day + average_invoices_per_day_standard_deviation
    hash.map do |key, invoice_objects|
      if invoice_objects.count > number
        array << key.capitalize
      else nil
      end
    end
    array
  end

  def invoice_object_per_day
    @sales_engine.invoices.all.group_by do |invoice|
      invoice.day
    end
  end

  def number_of_invoices_per_day
    array = invoice_object_per_day.map do |day, invoice_items|
      invoice_items = invoice_items.count
    end
  end

  def invoice_object_per_status
    @sales_engine.invoices.all.group_by do |invoice_obj|
      invoice_obj.status
    end
  end

  def invoice_status(status)
    status = status.to_sym
    total_per_status = invoice_object_per_status[status]
    total_status_count = total_per_status.length
    total_invoices = @sales_engine.invoices.all.length
    percentage = ((total_status_count.to_f / total_invoices.to_f) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    invoice_transactions = @sales_engine.transactions.find_all_by_invoice_id(invoice_id)
    transactions_by_date = invoice_transactions.sort_by do |transaction|
      transaction.updated_at
    end
    if transactions_by_date.length == 0
      return false
    elsif transactions_by_date[0].result == :success
      return true
    else
      return false
    end
  end

  def invoice_total(invoice_id)
    all_invoice_items = @sales_engine.invoice_items.find_all_by_invoice_id(invoice_id)
    total = all_invoice_items.reduce(0) do |invoice_total, invoice_item|
      invoice_total += invoice_item.total_price
      invoice_total
    end
    bd_total = (total * 100).round(0)
    total = (BigDecimal(bd_total) / 100)
  end

end
