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

class InvoiceTest < MiniTest::Test
  def test_it_exists
    invoice = Invoice.new({:id => 2, :customer_id => 22, created_at: Time.now, updated_at: Time.now})
    assert_instance_of Invoice, invoice
  end

  def test_creates_id_creates_a_new_id
    invoice = Invoice.new({:id => 2, :customer_id => 22, created_at: Time.now, updated_at: Time.now})
    assert_equal 5, invoice.create_id(5)
  end

  def test_day_checks_day_of_the_week
    invoice = Invoice.new({:id => 2, :customer_id => 22, created_at: Time.now, updated_at: Time.now})
    assert_equal "wednesday", invoice.day
  end
end
