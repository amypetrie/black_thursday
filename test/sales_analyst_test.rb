require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/item'
require_relative '../lib/item_repo'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < MiniTest::Test
  # def test_it_exists
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/items.csv",
  #   :merchants => "./data/merchants.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #
  #   assert_instance_of SalesAnalyst, sales_engine.analyst
  # end
  #
  # def test_average_items_per_merchant
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/items.csv",
  #   :merchants => "./data/merchants.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   assert_equal 2.88, sales_analyst.average_items_per_merchant
  # end
  #
  # def test_find_number_item_objects_per_merchant
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   assert_equal 7, sales_analyst.item_object_per_merchant.count
  # end
  #
  # def test_find_number_of_items_per_merchant
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   expected = [1,1,1,1,1,3,1]
  #   assert_equal expected, sales_analyst.number_of_items_per_merchant
  # end
  # #
  # # def test_find_standard_devation_step_one
  # #   sales_engine = SalesEngine.from_csv({
  # #   :items     => "./data/sample_item_data.csv",
  # #   :merchants => "./data/sample_merchant_file.csv",
  # #   :invoices => "./data/invoices.csv",
  # #   :invoice_items => "./data/invoice_items.csv"
  # #   })
  # #   sales_analyst = sales_engine.analyst
  # #   expected = [0.08410000000000002, 0.08410000000000002, 0.08410000000000002, 0.08410000000000002, 0.08410000000000002, 2.9240999999999997, 0.08410000000000002]
  # #   assert_equal expected, sales_analyst.find_standard_deviation_step_one
  # # end
  # #
  # # def test_find_standard_devation_step_two
  # #   sales_engine = SalesEngine.from_csv({
  # #   :items     => "./data/sample_item_data.csv",
  # #   :merchants => "./data/sample_merchant_file.csv",
  # #   :invoices => "./data/invoices.csv",
  # #   :invoice_items => "./data/invoice_items.csv"
  # #   })
  # #   sales_analyst = sales_engine.analyst
  # #   expected = 3.4286999999999996
  # #   assert_equal expected, sales_analyst.find_standard_deviation_step_two
  # # end
  # #
  # # def test_find_standard_devation_step_three
  # #   sales_engine = SalesEngine.from_csv({
  # #   :items     => "./data/sample_item_data.csv",
  # #   :merchants => "./data/sample_merchant_file.csv",
  # #   :invoices => "./data/invoices.csv",
  # #   :invoice_items => "./data/invoice_items.csv"
  # #   })
  # #   sales_analyst = sales_engine.analyst
  # #   expected = 0.5714499999999999
  # #   assert_equal expected, sales_analyst.find_standard_deviation_step_three
  # # end
  #
  # def test_find_standard_deviation
  #   skip
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/items.csv",
  #   :merchants => "./data/merchants.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #
  #   assert_equal 3.26, sales_analyst.find_standard_deviation
  # end
  #
  # def test_find_merchants_with_high_item_count
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #
  #   assert_instance_of Hash, sales_analyst.merchant_and_item_count_hash
  #
  # end
  #
  # def test_find_merchant_ids_with_high_item_count
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #
  #   assert_equal 1, sales_analyst.find_merchant_ids_with_high_item_count.length
  # end
  #
  # def test_find_merchant_objects_with_high_item_count
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #
  #   assert_equal 1, sales_analyst.merchants_with_high_item_count.length
  # end
  #
  # def test_average_item_price_for_merchant
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   id = 1233400
  #
  #   assert_equal (BigDecimal(3424) / 100), sales_analyst.average_item_price_for_merchant(id)
  # end
  #
  # def test_average_average_item_price_for_merchant
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #
  #
  #   assert_instance_of BigDecimal, sales_analyst.average_average_price_per_merchant
  # end
  #
  # def test_item_price_find_standard_deviation
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/invoices.csv",
  #   :invoice_items => "./data/invoice_items.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   array = sales_analyst.average_item_price_array
  #   average = sales_analyst.array_average_value(array)
  #   expected = sales_analyst.find_standard_deviation(array, average, "sample")
  #
  #   assert_equal 155.77, expected
  # end
  #
  # def test_total_revenue_by_date
  #   sales_engine = SalesEngine.from_csv({
  #   :items     => "./data/sample_item_data.csv",
  #   :merchants => "./data/sample_merchant_file.csv",
  #   :invoices => "./data/sample_invoices_data.csv",
  #   :invoice_items => "./data/sample_invoice_item_data.csv",
  #   :transactions => "./data/sample_transactions_file.csv",
  #   :customers => "./data/sample_customer_file.csv"
  #   })
  #   sales_analyst = sales_engine.analyst
  #   date = Time.parse("2012-02-26")
  #
  #   assert_instance_of BigDecimal, sales_analyst.total_revenue_by_date(date)
  # end

  def test_merchants_by_transaction_status
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv",
    :transactions => "./data/transactions.csv",
    :customers => "./data/customers.csv"
    })
    sales_analyst = sales_engine.analyst
    sales_analyst.merchants_by_transaction_result(:success)

    assert_equal "", sales_analyst.paid_for_invoice_items.length
  end
end
