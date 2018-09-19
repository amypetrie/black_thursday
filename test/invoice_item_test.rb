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

class InvoiceItemTest < MiniTest::Test
  def test_it_exists
    invoice_item = InvoiceItem.new({:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 20, :unit_price => 30, :created_at => Time.now, :updated_at => Time.now})
    assert_instance_of InvoiceItem, invoice_item
  end

  def test_unit_price_to_dollars_returns_in_correct_format
    invoice_item = InvoiceItem.new({:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 20, :unit_price => 3000, :created_at => Time.now, :updated_at => Time.now})
    assert_equal 30, invoice_item.unit_price_to_dollars
  end

  def test_create_id_creates_a_new_id
    invoice_item = InvoiceItem.new({:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 20, :unit_price => 30, :created_at => Time.now, :updated_at => Time.now})
    assert_equal 44, invoice_item.create_id(44)
  end

  def test_total_price_returns_total_price
    invoice_item = InvoiceItem.new({:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 20, :unit_price => 30, :created_at => Time.now, :updated_at => Time.now})
    assert_equal 6, invoice_item.total_price
  end
end
