require_relative "../lib/repo_methods"

class InvoiceItemRepository
  include RepoMethods

  attr_reader :data_file,
              :invoice_items

  def initialize(data_file, invoice_items)
    @data_file = data_file
    @invoice_items = invoice_items
  end

  def all
    @invoice_items
  end

  def load_repo(invoice_item_array)
    @invoice_items = invoice_item_array.flatten
  end

  def find_all_by_item_id(item_id)
    item_id = item_id.to_i
    @invoice_items.find_all do |item|
      item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_id = invoice_id.to_i
    @invoice_invoices.find_all do |invoice|
      invoice.invoice_id == invoice_id
    end
  end

  def find_highest_invoice_id
    m = @invoices_items.max_by do |invoice|
      invoice.id
    end
    m.id
  end

  def create(attributes)
    invoice = InvoiceItem.new(attributes)
    invoice.create_id(find_highest_invoice_id + 1)
    @invoices_items << invoice_item
    invoice_item
  end

  def update(id, attributes)
    invoice_item = find_by_id(id)
    if invoice_item == nil
      do_nothing
    else
      invoice_item.quantity = attributes[:quantity]
      invoice_item.unit_price = attributes[:unit_price]
      invoice_item.updated_at = Time.now
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
