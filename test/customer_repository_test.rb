require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < MiniTest::Test
  def test_it_exists
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    assert_instance_of CustomerRepo, se.customer_repo
  end

  def test_all_return_all_customer_instances
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    assert_equal 1000, se.customer_repo.all.count
  end

  def test_find_by_id_returns_object_with_matching_id
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    assert_equal "Ramona", se.customer_repo.find_by_id(10).first_name
  end

  def test_find_all_by_first_name_returns_objects_with_matching_names
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    assert_equal 1, se.customer_repo.find_all_by_first_name("Ramona").count
  end

  def test_find_all_by_last_name_returns_objects_with_matching_names
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    assert_equal 3, se.customer_repo.find_all_by_last_name("Reynolds").count
  end

  def test_creates_a_new_instance_of_customer
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    attributes = {id: 200, first_name: "Heru", last_name: "Semahj"}
    assert_equal "Heru", se.customer_repo.create(attributes).first_name
    assert_equal "Semahj", se.customer_repo.create(attributes).last_name
  end

  def test_update_updates_first_name_and_last_name_and_updated_at
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    attributes = {id: 200, first_name: "Ankh", last_name: "Semahj"}
    cr = se.customers
    id = 1
    obj = cr.find_by_id(id)
    cr.update(id, attributes)
    assert_equal "Ankh", obj.first_name
    assert_equal "Semahj", obj.last_name
  end

  def test_delete_deletes_object_with_matching_id
    se = SalesEngine.from_csv({
      :customers => "./data/customers.csv"
    })
    cr = se.customers
    customer = cr.find_by_id(1)
    cr.delete(1)
    refute se.customers.all.include?(customer)
  end
end
