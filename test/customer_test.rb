require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/customer'

class CustomerTest < MiniTest::Test
  def test_it_exists
    customer = Customer.new({id:20,first_name: "Jeremiah",last_name: "Dawking",created_at: Time.now, updated_at: Time.now})
    assert_instance_of Customer, customer
  end

  def test_it_has_attributes
    customer = Customer.new({id:20,first_name: "Jeremiah",last_name: "Dawking",created_at: Time.now, updated_at: Time.now})
    assert_equal 20, customer.id
    assert_equal "Jeremiah", customer.first_name
    assert_equal "Dawking", customer.last_name
    assert_equal Time.now.to_s, customer.created_at.to_s
    assert_equal Time.now.to_s, customer.updated_at.to_s
  end
end
