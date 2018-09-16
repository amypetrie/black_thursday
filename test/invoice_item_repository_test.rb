require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'

class InvoiceItemRepositoryTest < MiniTest::Test
  def test_it_exists
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })

    ii = se.invoice_items.all
    assert_instance_of InvoiceItemRepository, ii
  end

  def test_all_returns_array_of_invoice_item_objects
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    ii = se.invoice_items
    assert_equal 4985, ii.all.length
  end

  def test_find_by_id_returns_matching_Id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    ii = se.invoice_items
    binding.pry
    id = 7
    expected_2 = 263563764

    assert_equal id, ii.find_by_id(id).idea
    assert_equal expected_2, ii.find_by_id(id).item_id
  end
end
