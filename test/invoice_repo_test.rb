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
      :invoices => "./data/invoices.csv"
    })
    assert_instance_of InvoiceRepo, se.invoices
  end

  def test_all_returns_array_of_merchant_objects
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    assert_equal 4985, se.invoices.all.count
  end

  def test_find_by_id_returns_invoice_id
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    id = 3
    expected_2 = 12335955

    assert_equal id, se.invoices.find_by_id(id).id
    assert_equal expected_2, se.invoices.find_by_id(id).merchant_id
  end

  def test_find_all_by_customer_id_returns_array_of_matching_invoices_by_customer_id
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    customer_id = 1
    assert_equal 8, se.invoices.find_all_by_customer_id(customer_id).count
  end

  def test_find_all_by_merchant_id_returns_array_of_matching_invoices_by_merchant_id
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    merchant_id = 12335955
    assert_equal 12, se.invoices.find_all_by_merchant_id(merchant_id).count
  end

  def test_find_all_by_status_returns_array_of_matching_invoices_by_status
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    status = "pending"
    assert_equal 1473, se.invoices.find_all_by_status(status).count
  end

  def test_create_creates_new_instance_of_invoice
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    ir = se.invoices
    attributes = {id: 777, customer_id: 54, merchant_id: 20, status: "shipped", created_at: Time.now, updated_at: Time.now }
    ir.create(attributes)
    expected_1 = 4986
    expected_2 = 54
    assert_equal expected_1, ir.find_by_id(expected_1).id
    assert_equal expected_2, ir.find_by_id(expected_1).customer_id
  end

  def test_update_will_update_status_attribute
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })

    id = 7
    attributes = {id: 7, status: "shipped"}

    assert_equal 7, se.invoices.update(id, attributes).id
    assert_equal "shipped", se.invoices.update(id, attributes).status
    assert_equal 1, se.invoices.update(id, attributes).customer_id
  end

  def test_delete_id_deletes_invoice_object_from_invoices_array
    se = SalesEngine.from_csv({
      :invoices => "./data/invoices.csv"
    })
    invoice = se.invoices
    invoiced = invoice.find_by_id(9)
    invoice.delete(9)

    refute invoice.invoices.include?(invoiced)
  end
end
