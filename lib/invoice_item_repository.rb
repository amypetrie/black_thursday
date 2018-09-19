require_relative '../lib/repo_methods'

class InvoiceItemRepository < CsvAdaptor
  include RepoMethods
  attr_reader :data_file,
              :invoice_items
  def initialize(data_file,invoice_items=[])
    @data_file = data_file
    @invoice_items = []
    @merchants = []
  end

  def all
    @invoice_items
  end

  def load_repo(invoice_item_array)
    @invoice_items = invoice_item_array.flatten
  end

  def create(attributes)
    invoice_item = InvoiceItem.new(attributes)
    invoice_item.create_id(find_highest_object_id + 1)
    @invoice_items << invoice_item
    invoice_item
  end

  def update(id, attributes)
    invoice_item = find_by_id(id)
    if invoice_item == nil
      do_nothing
    else
      invoice_item.quantity = attributes[:quantity] unless attributes[:quantity] == nil
      invoice_item.unit_price = attributes[:unit_price] unless attributes[:unit_price] == nil
      invoice_item.updated_at = Time.now
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.length} rows>"
  end
end
