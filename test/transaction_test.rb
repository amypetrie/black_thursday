require 'pry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test

  def test_it_exists
    t = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => Time.now,
    :updated_at => Time.now
    })

    assert_instance_of Transaction, t
  end

  def test_it_has_attributes
    t = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => Time.now,
    :updated_at => Time.now
    })

    assert_equal 6, t.id
    assert_equal 8, t.invoice_id
    assert_instance_of String, t.credit_card_number
    assert_instance_of String, t.credit_card_expiration_date
    assert_instance_of Time, t.created_at
    assert_instance_of Time, t.updated_at
    assert_equal "success", t.result
  end

  def test_last_updated_date_returns_plain_date_string
    t = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => Time.now,
    :updated_at => Time.now
    })

    assert_equal "2018-09-17", t.last_updated_date
  end
end
