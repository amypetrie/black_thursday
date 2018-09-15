require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/invoice_repo'


class InvoiceRepoTest < MiniTest::Test
  def test_it_exists
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    assert_instance_of InvoiceRepo, invoice
  end

  def test_all_returns_array_of_merchant_objects
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices

    assert_equal 4985, se.invoices.all.count
  end

  def test_find_by_id_returns_invoice_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    invoice.all
    id = 3
    expected_2 = 12335955

    assert_equal id, invoice.find_by_id(id).id
    assert_equal expected_2, invoice.find_by_id(id).merchant_id
  end

  def test_find_all_by_customer_id_returns_array_of_matching_invoices_by_customer_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    customer_id = 1
    assert_equal 8, invoice.find_all_by_customer_id(customer_id).count
  end

  def test_find_all_by_merchant_id_returns_array_of_matching_invoices_by_merchant_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    merchant_id = 12335955
    assert_equal 12, invoice.find_all_by_merchant_id(merchant_id).count
  end

  def test_find_all_by_status_returns_array_of_matching_invoices_by_status
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    status = "pending"
    assert_equal 1473, invoice.find_all_by_status(status).count
  end

  def test_create_creates_new_instance_of_invoice
    skip
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    attributes = {id: 777, created_at: "2018-09-08", merchant_id: 5}
    expected_1 = 777
    expected_2 = 5
    assert_equal expected_1, invoice.create(attributes).name
    assert_equal expected_2, invoice.create(attributes).merchant_id
  end

  def test_update_will_update_status_attribute
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    id = 7
    attributes = {id: 7, status: "shipped"}
    invoice.update(id, attributes)

    assert_equal 7, invoice.update(id, attributes).id
    assert_equal "shipped", invoice.update(id, attributes).status
    assert_equal 1, invoice.update(id, attributes).customer_id
  end

  def test_delete_id_deletes_invoice_object_from_invoices_array
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
      :merchants => "./data/sample_merchant_file.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice = se.invoices
    invoiced = invoice.find_by_id(9)
    invoice.delete(9)

    refute invoice.invoices.include?(invoiced)
  end
end
