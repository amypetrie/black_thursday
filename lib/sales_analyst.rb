require_relative '../lib/repo_methods'
require 'time'
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
    results = invoice_transactions.map do |transaction|
      transaction.result
    end
    if results.include? :success
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

  #iteration4

  def total_revenue_by_date(date)#=> $$
    revenue_date = [date.year, date.month, date.day]
    invoices_by_date = @sales_engine.invoices.all.find_all do |invoice|
      invoice.created_at_date == revenue_date
    end
    invoice_ids = invoices_by_date.map {|invoice| invoice.id}
    invoice_items = []
    invoice_ids.each do |invoice_id|
      invoice_items << @sales_engine.invoice_items.find_all_by_invoice_id(invoice_id)
    end
    prices = invoice_items.flatten.map do |item|
      item.total_price
    end
    total = prices.inject(0) do |total, price|
      total += price
    end
    big_decimal = (total * 100).round(0)
    BigDecimal(big_decimal) / 100
  end

  def merchant_paid_invoices(merchant_id)
    merchant_invoices = @sales_engine.invoices.find_all_by_merchant_id(merchant_id)
    paid_invoices = []
    merchant_invoices.each do |invoice|
      if invoice_paid_in_full?(invoice.id) == true
        paid_invoices << invoice
      end
    end
    paid_invoices
  end

  def revenue_by_merchant(merchant_id)
    total = merchant_paid_invoices(merchant_id).inject(0) do |total, invoice|
      total += invoice_total(invoice.id)
    end
    big_decimal = (total * 100).round(0)
    BigDecimal(total) / 100
  end

  def merchant_to_revenue(merchant_id)
    [merchant_id, revenue_by_merchant(merchant_id)]
  end

  def merchants_ranked_by_revenue
    revenue_array = @sales_engine.merchants.all.map do |merchant|
      merchant_to_revenue(merchant.id)
    end
    ranked = revenue_array.sort_by do |array|
      array[1]
    end
    final = ranked.map do |array_pair|
      @sales_engine.merchants.find_by_id(array_pair[0])
    end.reverse
  end

  def top_revenue_earners(num=20)
    final_index = num - 1
    merchants_ranked_by_revenue[(0..final_index)]
  end

  def paid_invoices_to_invoice_items(merchant_id)
    invoices = merchant_paid_invoices(merchant_id)
    invoice_items = invoices.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end
  end
# find the InvoiceItem with the highest quantity for a particular merchant
  def most_sold_item_for_merchant(merchant_id)
    highest_item_ids_per_merchant(merchant_id).map do |id|
      @sales_engine.items.find_by_id(id)
    end
  end

  def paid_invoice_items_to_items(merchant_id)
    items = paid_invoices_to_invoice_items(merchant_id).flatten.map do |invoice_item|
      @sales_engine.items.find_by_id(invoice_item.item_id)
    end
  end

  def highest_item_ids_per_merchant(merchant_id)
    paid_invoices_to_invoice_items(merchant_id).flatten.map do |invoice_item|
      if invoice_item.quantity.to_i == highest_quantity_of_item_for_merchant(merchant_id)
        invoice_item.item_id
      end
    end.compact
  end

  def highest_quantity_of_item_for_merchant(merchant_id)
    quantities = paid_invoices_to_invoice_items(merchant_id).flatten.map do |item|
      item.quantity.to_i
    end
    quantities.max
  end

  def best_item_for_merchant(merchant_id)
    id = highest_total_price_item_id(merchant_id)
    @sales_engine.items.find_by_id(id)
  end

  def highest_total_price_item_id(merchant_id)
    sort_invoice_items_by_revenue(merchant_id).first.item_id
  end

  def sort_invoice_items_by_revenue(merchant_id)
    prices = paid_invoices_to_invoice_items(merchant_id).flatten.group_by do |invoice_item|
      invoice_item.total_price
    end
    max = prices.values.flatten.sort_by do |invoice_item|
      invoice_item.total_price
    end.reverse
  end

  def invoice_item_to_item_id(merchant_id)
    paid_invoices_to_invoice_items(merchant_id).flatten.group_by do |invoice_item|
      invoice_item.item_id
    end
  end

  def merchants_with_only_one_item
    @sales_engine.merchants.all.find_all do |merchant|
      item_total = @sales_engine.items.find_all_by_merchant_id(merchant.id)
      item_total.length == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    @sales_engine.merchants.all.find_all do |merchant|
      item_total = @sales_engine.items.find_all_by_merchant_id(merchant.id)
      item_total.length == 1 && merchant.created_at.strftime("%B") == month
    end
  end

  #ook for invoices only failed transactions (they must have transactions, but
  #each of those transactions must be a failure).
  #returns merchant array
  def merchants_with_pending_invoices
    merchant_ids = @sales_engine.invoices.all.map do |invoice|
      ii = invoice.id
      if invoice_paid_in_full?(ii) == false
        invoice.merchant_id
      else
        nil
      end
    end
    final_ids = merchant_ids.compact.uniq
    final_ids.map do |id|
      @sales_engine.merchants.find_by_id(id)
    end.compact
  end

  #   pending_invoices = @sales_engine.invoices.all.find_all do |invoice|
  #     invoice.status == :pending
  #   end
  #   merchants_with_pending_inv = pending_invoices.map do |pi|
  #     pi.merchant_id
  #   end
  #   merchants_with_pending_inv = merchants_with_pending_inv.uniq
  #   final = merchants_with_pending_inv.concat(merchants_with_pending_transactions).uniq
  #   binding.pry
  # end

  # def merchants_with_pending_transactions
  #   invoice_to_transactions = @sales_engine.transactions.all.group_by do |transaction|
  #     transaction.invoice_id
  #   end
  #   invoice_results = invoice_to_transactions.each_pair do |invoice_id, transactions|
  #       invoice_to_transactions[invoice_id] = transactions.map {|trans| trans.result}
  #   end
  #   success = []
  #   pending = []
  #   invoice_results.each_pair do |invoice_id, results|
  #     if results.include? :success
  #       success << invoice_id
  #     else
  #       pending << invoice_id
  #     end
  #   end
  #   merchant_array = pending.map do |invoice_id|
  #     @sales_engine.invoices.find_by_id(invoice_id).merchant_id
  #   end
  #   merchant_array.uniq
  # end

end
