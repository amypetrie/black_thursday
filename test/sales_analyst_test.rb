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
  def test_it_exists
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })

    assert_instance_of SalesAnalyst, sales_engine.analyst
  end

  def test_average_items_per_merchant
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    assert_equal 2.88, sales_analyst.average_items_per_merchant
  end

  def test_find_number_item_objects_per_merchant
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    assert_equal 7, sales_analyst.item_object_per_merchant.count
  end

  def test_find_number_of_items_per_merchant
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    expected = [1,1,1,1,1,3,1]
    assert_equal expected, sales_analyst.number_of_items_per_merchant
  end

  def test_find_standard_deviation
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    array = [1,2,3,4,5]
    average = 3

    assert_equal 1.41, sales_analyst.find_standard_deviation(array, average, "sample")
  end

  def test_find_merchants_with_high_item_count
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst

    assert_instance_of Hash, sales_analyst.merchant_and_item_count_hash

  end

  def test_find_merchant_ids_with_high_item_count
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst

    assert_equal 1, sales_analyst.find_merchant_ids_with_high_item_count.length
  end

  def test_find_merchant_objects_with_high_item_count
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst

    assert_equal 1, sales_analyst.merchants_with_high_item_count.length
  end

  def test_average_item_price_for_merchant
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    id = 1233400

    assert_equal (BigDecimal(3424) / 100), sales_analyst.average_item_price_for_merchant(id)
  end

  def test_average_average_item_price_for_merchant
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst


    assert_instance_of BigDecimal, sales_analyst.average_average_price_per_merchant
  end

  def test_item_price_find_standard_deviation
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv"
    })
    sales_analyst = sales_engine.analyst
    array = sales_analyst.average_item_price_array
    average = sales_analyst.array_average_value(array)
    expected = sales_analyst.find_standard_deviation(array, average, "sample")

    assert_equal 155.77, expected
  end

  def test_total_revenue_by_date
    sales_engine = SalesEngine.from_csv({
    :items     => "./data/sample_item_data.csv",
    :merchants => "./data/sample_merchant_file.csv",
    :invoices => "./data/sample_invoices_data.csv",
    :invoice_items => "./data/sample_invoice_item_data.csv",
    :transactions => "./data/sample_transactions_file.csv",
    :customers => "./data/sample_customer_file.csv"
    })
    sales_analyst = sales_engine.analyst
    date = Time.parse("2012-02-26")

    assert_instance_of BigDecimal, sales_analyst.total_revenue_by_date(date)
  end

  def test_merchants_paid_invoices
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst
    assert_equal 4, sales_analyst.merchant_paid_invoices(1233400).length
  end

  def test_golden_items
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 8531851, sales_analyst.golden_items[0].id
  end

  def test_invoice_item_per_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 6, sales_analyst.invoice_object_per_merchant.length
  end

  def test_number_of_invoices_per_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 6, sales_analyst.number_of_invoices_per_merchant.length
  end

  def test_average_invoices_per_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 1.71, sales_analyst.average_invoices_per_merchant
  end

  def test_merchant_and_invoice_count_hash_creates_a_hash
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_instance_of Hash, sales_analyst.merchant_and_invoice_count_hash
  end

  def test_invoice_thresholds
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst
    expected_bottom = -3.2300000000000004

    assert_equal 6.65, sales_analyst.top_invoice_threshold
    assert_equal expected_bottom, sales_analyst.bottom_invoice_threshold
  end

  def test_top_days_by_invoice_count
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 2, sales_analyst.top_days_by_invoice_count.length
  end

  def test_merchants_with_pending_invoices
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 1, sales_analyst.merchants_with_pending_invoices.length
  end

  def test_merchants_with_only_one_item
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 6, sales_analyst.merchants_with_only_one_item.length
  end

  def test_sort_invoice_items_by_revenue
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 0, sales_analyst.sort_invoice_items_by_revenue(12334105).length
  end

  def test_paid_invoices_to_invoice_items
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 0, sales_analyst.paid_invoices_to_invoice_items(12334105).length
  end

  def test_revenue_ranked_to_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 7, sales_analyst.merchants_ranked_by_revenue.length
  end

  def test_bottom_merchants_by_invoice_count
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal [], sales_analyst.bottom_merchants_by_invoice_count
  end

  def test_merchants_with_only_one_item_registered_in_month
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal [], sales_analyst.merchants_with_only_one_item_registered_in_month("August")
  end

  def test_invoice_status
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 58.33, sales_analyst.invoice_status(:pending)
  end

  def test_highest_item_ids_per_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 0, sales_analyst.highest_item_ids_per_merchant(12334105).length
  end

  def test_invoice_item_to_item_id
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst
    expected = {}

    assert_equal expected, sales_analyst.invoice_item_to_item_id(12334105)
  end

  def test_best_item_for_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal nil, sales_analyst.best_item_for_merchant(1233400)
  end

  def test_highest_total_price_item_id
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 263515158, sales_analyst.highest_total_price_item_id(1233400)
  end

  def test_highest_quantity_of_item_for_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 7, sales_analyst.highest_quantity_of_item_for_merchant(1233400)
  end

  def test_paid_invoice_items_to_items
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/sample_invoices_data.csv",
      :invoice_items => "./data/sample_invoice_item_data.csv",
      :transactions => "./data/sample_transactions_file.csv",
      :customers => "./data/sample_customer_file.csv"
      })
    sales_analyst = sales_engine.analyst

    assert_equal 4, sales_analyst.paid_invoice_items_to_items(1233400).length
  end

end
