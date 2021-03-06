require_relative '../lib/repo_methods'

class InvoiceRepo

include RepoMethods

  attr_reader :data_file,
              :invoices

  def initialize(data_file, invoices)
    @data_file = data_file
    @invoices = invoices
  end

  def load_repo(invoice_array)
    @invoices = invoice_array.flatten
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
    status = status.to_sym
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
