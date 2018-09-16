require_relative '../lib/repo_methods'

class InvoiceItemRepository < CsvAdaptor
  include RepoMethods
  attr_reader :data_file,
              :invoice_items
  def initialize(data_file,invoice_items=[])
    @data_file = data_file
    @invoice_items = []
  end

  def all
    @invoice_items
  end

  # def find_highest_invoice_id
  #   m = @invoices_items.max_by do |invoice|
  #     invoice.id
  #   end
  #   m.id
  # end

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

  def invoice_item_array_from_file
    invoice_item_array = []
    load_invoice_items(@data_file).each do |invoice_info|
      invoice_item_array << InvoiceItem.new(invoice_info)
    end
    invoice_item_array
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
