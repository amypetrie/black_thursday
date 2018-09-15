require_relative '../lib/repo_methods'

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
    find_standard_deviation(array, "sample")
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
    standard_deviation = find_standard_deviation(array, "sample")
    average = array_average_value(array)
    golden_value = average + (standard_deviation * 2)
    @sales_engine.items.all.find_all do |item|
      item.price > golden_value
    end
  end

end
