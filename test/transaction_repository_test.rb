require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/transaction_repo'

class TransactionRepoTest < MiniTest::Test
  def test_it_exists
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })
    assert_instance_of TransactionRepo, se.transaction_repo
  end

  def test_all_item_characteristics_imports_item_objects_into_items_array
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })
    assert_instance_of Array, se.transaction_repo.all
  end

  def test_all_returns_array_of_item_objects
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })
    assert_equal 4985, se.transactions.all.count
  end

  def test_find_by_id_returns_item_id
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })
    id = 7
    expected_2 = 1298

    assert_equal id, se.transactions.find_by_id(id).id
    assert_equal expected_2, se.transactions.find_by_id(id).invoice_id
  end

  def test_find_by_invoice_id_returns_item_object
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })

  invoice_id = 1298

    assert_equal 1, se.transactions.find_all_by_invoice_id(invoice_id).count
  end

  def test_find_all_by_credit_card_number_returns_items_with_matching_card_number
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })
    credit_card_number = 4068631943231473

    assert_equal 1, se.transactions.find_all_by_credit_card_number(credit_card_number).count
  end

  def test_find_all_by_result_returns_item_with_matching_result
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })

    result = :success
    assert_equal 4158, se.transactions.find_all_by_result(result).count
  end
#
#   def test_find_all_by_price_in_range_returns_array_of_items_in_range
#     se = SalesEngine.from_csv({
#       :items     => "./data/sample_item_data.csv"
#     })
#
#     range = (0..200)
#     #unsure of this method
#     assert_equal 8, se.items.find_all_by_price_in_range(range).count
#   end
#
#   def test_find_all_by_merchant_id_returns_array_of_matching_items_by_merchant_id
#     se = SalesEngine.from_csv({
#       :items     => "./data/sample_item_data.csv"
#     })
#     merchant_id = "1233400"
#     assert_equal 3, se.items.find_all_by_merchant_id(merchant_id).count
#   end
#
#   def test_find_highest_item_id
#     se = SalesEngine.from_csv({
#       :items     => "./data/sample_item_data.csv"
#     })
#     assert_equal 372872193712983129, se.items.find_highest_item_id
#   end

  def test_create_creates_new_instance_of_item
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })

    attributes = {id: 500, created_at: "2018-09-08", updated_at: 5}
    expected_1 = 4986
    expected_2 = Time.now
    assert_equal expected_1, se.transactions.create(attributes).id
    assert_equal expected_2, se.transactions.create(attributes).updated_at
  end

  def test_update_will_update_cc_number_cc_expiration_date_result_and_updated_at
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })

    id = 4378423
    attributes = {credit_card_number: 5005934823, credit_card_expiration_date: 0220, result: "success"}

    assert_equal 5005934823, se.items.update(id, attributes).credit_card_number
    assert_equal 0220, se.items.update(id, attributes).credit_card_expiration_date
    assert_equal 10, se.items.update(id, attributes).result
  end

  def test_delete_id_deletes_item_object_from_items_array
    se = SalesEngine.from_csv({
      :transactions => "./data/transactions.csv"
    })

    transaction = se.transactions.find_by_id(2)
    se.transactions.delete(2)
    refute se.transactions.all.include?(transaction)
  end
end
