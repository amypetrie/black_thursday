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
      :invoice_items => "./data/invoice_items.csv"
    })
    assert_instance_of InvoiceItemRepository, se.invoice_items
  end

  def test_all_returns_array_of_invoice_item_objects
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    assert_equal 21830, se.invoice_items.all.count
  end

  def test_find_by_id_returns_matching_id
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    id = 7
    expected_2 = 263563764

    assert_equal id, se.invoice_items.find_by_id(id).id
    assert_equal expected_2, se.invoice_items.find_by_id(id).item_id
  end

  def test_find_all_by_item_id_returns_matching_item_id
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    item_id = 263515158
    assert_equal 20, se.invoice_items.find_all_by_item_id(item_id).count
  end

  def test_find_all_by_invoice_id_returns_matching_invoice_id
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    invoice_id = 1
    assert_equal 8, se.invoice_items.find_all_by_invoice_id(invoice_id).count
  end

  def test_create_creates_a_new_invoice_item
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    attributes = {:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 20, :unit_price => 30, :created_at => Time.now, :updated_at => Time.now}
    expected_1 = 21831
    expected_2 = 30000
    created = se.invoice_items.create(attributes)
    assert_equal expected_1, created.id
    assert_equal expected_2, created.invoice_id
  end

  def test_update_updates_objects_attributes
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    attributes = {:id => 42, :item_id => 22, :invoice_id => 30000, :quantity => 700, :unit_price => 400, :created_at => Time.now, :updated_at => Time.now}
    ii = se.invoice_items
    id = 7
    obj = ii.find_by_id(id)
    ii.update(id, attributes)
    assert_equal 700, obj.quantity
    assert_equal 400, obj.unit_price
    assert_nil nil, se.invoice_items.do_nothing
  end

  def test_do_nothing_does_nothing
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    assert_nil nil, se.invoice_items.do_nothing
  end

  def test_delete_id_deletes_invoice_object_from_invoices_array
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    ir = se.invoice_items
    invoice_item = ir.find_by_id(9)
    ir.delete(9)
    refute ir.invoice_items.include?(invoice_item)
  end

  def test_inspect_checks_insepct_method
    se = SalesEngine.from_csv({
      :invoice_items => "./data/invoice_items.csv"
    })
    assert_equal 31, se.invoice_items.inspect.length
  end
end
