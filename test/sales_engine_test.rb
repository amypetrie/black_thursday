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

class SalesEngineTest < Minitest::Test

  def test_it_exists
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })

    assert_instance_of SalesEngine, se
  end

  def test_it_has_attributes
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })

    assert_equal "./data/sample_item_data.csv", se.item_file
    assert_equal "./data/sample_merchant_file.csv", se.merchant_file
  end

  def test_merchants_and_items_creates_instances_of_repos
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })

    assert_instance_of MerchantRepo, se.merchants
    assert_instance_of ItemRepo, se.items
  end

  def test_test_analyst_creates_sales_analyst
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })

    assert_instance_of SalesAnalyst, se.analyst
  end

end
