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

class ItemRepoTest < Minitest::Test

  def test_it_exists
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    assert_instance_of ItemRepo, se.ir
  end

  def test_all_item_characteristics_imports_item_objects_into_items_array
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    assert_instance_of Array, se.items.all
  end

  def test_all_returns_array_of_item_objects
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    assert_equal 9, se.items.all.count
  end

  def test_find_by_id_returns_item_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    id = 4378423
    expected_2 = "test2"

    assert_equal id, se.items.find_by_id(id).id
    assert_equal expected_2, se.items.find_by_id(id).name
  end
#
  def test_find_by_name_returns_item_object
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    name = "test3"
    expected_2 = 8531851

    assert_equal name, se.items.find_by_name(name).name
    assert_equal expected_2, se.items.find_by_name(name).id
  end

  def test_find_all_with_description_returns_items_with_description_fragment
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    name = "des"

    assert_equal 9, se.items.find_all_with_description(name).count
  end

  def test_find_all_by_price_returns_array_of_matching_items_by_price
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    price = BigDecimal(34.24,4)
    assert_equal 5, se.items.find_all_by_price(price).count
  end
#
  def test_find_all_by_price_in_range_returns_array_of_items_in_range
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    range = (0..200)
    assert_equal 8, se.items.find_all_by_price_in_range(range).count
  end

  def test_find_all_by_merchant_id_returns_array_of_matching_items_by_merchant_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    merchant_id = "1233400"
    assert_equal 3, se.items.find_all_by_merchant_id(merchant_id).count
  end

  def test_find_highest_item_id
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })
    assert_equal 372872193712983129, se.items.find_highest_item_id
  end

  def test_create_creates_new_instance_of_item
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    attributes = {name: "TEST_ITEM", created_at: "2018-09-08", merchant_id: 5, unit_price: 1000}
    expected_1 = "TEST_ITEM"
    expected_2 = 5
    assert_equal expected_1, se.items.create(attributes).name
    assert_equal expected_2, se.items.create(attributes).merchant_id
  end

  def test_update_will_update_name_description_unit_price_and_updated_at_attributes
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv"
    })

    id = 4378423
    attributes = {name: "TEST_ITEM", description: "Test Description", unit_price: 10}
    assert_equal "TEST_ITEM", se.items.update(id, attributes).name
    assert_equal "Test Description", se.items.update(id, attributes).description
    assert_equal 10, se.items.update(id, attributes).unit_price
  end

  def test_delete_id_deletes_item_object_from_items_array
    se = SalesEngine.from_csv({
      :items     => "./data/sample_item_data.csv",
    })

    item = se.ir.find_by_id(4378423)
    se.ir.delete(4378423)
    refute se.ir.items.include?(item)
  end
end
