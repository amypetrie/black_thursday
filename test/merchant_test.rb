require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'

class MerchantTest < Minitest::Test

  def test_it_exists
    m = Merchant.new({:id => 5, :name => "Turing School"})
    assert_instance_of Merchant, m
  end

  def test_it_has_name_and_id_attributes
    m = Merchant.new({:id => 5, :name => "Turing School"})
    assert_equal 5, m.id
    assert_equal "Turing School", m.name
  end

  def test_create_id_creates_new_id
    m = Merchant.new({:id => 5, :name => "Turing School"})
    m.create_id(54678)
    assert_equal 54678, m.create_id(54678)
  end

  def test_change_name_can_change_name
    m = Merchant.new({:id => 5, :name => "Turing School"})
    assert_equal "Roger", m.change_name("Roger")
  end

  def test_change_updated_at
    m = Merchant.new({:id => 5, :name => "Turing School"})

    assert_instance_of Time, m.change_updated_at
  end

end
