require 'time'
require 'bigdecimal'
require_relative '../lib/sales_engine'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/item'
require_relative '../lib/item_repo'
require_relative '../lib/invoice'
require_relative '../lib/repo_methods'

class InvoiceRepo < CsvAdaptor
include RepoMethods
  attr_reader :data_file,
              :invoices
  def initialize(data_file, invoices=[])
    @data_file = data_file
    @invoices = invoices
  end

  def invoice_array_from_file
    load_invoices(data_file).each do |invoice_info|
      @invoices << Invoice.new(invoice_info)
    end
  end

  def all
    @invoices
  end

  def find_all_by_customer_id(customer_id)
    customer_id = customer_id.to_i
    all.find_all do |object|
      object.customer_id == customer_id
    end
  end

  def find_all_by_status(status)
    status = status.to_s
    all.find_all do |object|
      object.status == status
    end
  end

  def create(attributes)
    invoice = Invoice.new(attributes)
    invoice.create_id(find_highest_object_id + 1)
    @invoices << invoice
    invoice
  end

  def update(id, attributes)
    invoice = find_by_id(id)
    if invoice == nil
      do_nothing
    else
      invoice.status = attributes[:status]
      time = Time.now
      invoice.updated_at = Time.now
    end
    invoice
  end





end
