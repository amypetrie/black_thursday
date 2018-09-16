require 'pry'
require_relative '../lib/csv_adaptor'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repo'
require_relative '../lib/item'
require_relative '../lib/item_repo'
require_relative '../lib/invoice_repo'
require_relative '../lib/invoice'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/customer'
require_relative '../lib/customer_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repo'
require_relative '../lib/repo_methods'

class SalesEngine < CsvAdaptor
  include RepoMethods

  attr_reader :item_file,
              :merchant_file,
              :invoice_file,
              :invoice_item_file,
              :transaction_file,
              :customer_file,
              :mr,
              :ir,
              :invoices,
              :invoice_item_repo,
              :customer_repo,
              :transaction_repo

  def self.from_csv(data)
    engine = SalesEngine.new(data)
  end

  def initialize(data)
    @invoice_file ||=data[:invoices]
    @item_file ||= data[:items]
    @merchant_file ||= data[:merchants]
    @invoice_item_file ||= data[:invoice_items]
    @transaction_file ||= data[:transactions]
    @customer_file ||=data[:customers]
    @ir = ItemRepo.new(@item_file, Array.new)
    @ir.load_repo(original_items)
    @mr = MerchantRepo.new(@merchant_file, Array.new)
    @mr.load_repo(original_merchants)
    @invoices = InvoiceRepo.new(@invoice_file, Array.new)
    @invoices.load_repo(original_invoices)
    @invoice_item_repo = InvoiceItemRepository.new(@invoice_item_file, Array.new)
    @invoice_item_repo.load_repo(original_invoice_items)
    @transaction_repo = TransactionRepo.new(@transaction_file, Array.new)
    @transaction_repo.load_repo(original_transactions)
    @customer_repo = CustomerRepo.new(@customer_file, Array.new)
    @customer_repo.load_repo(original_customers)
  end

  def items
    @ir
  end

  def merchants
    @mr
  end

  def invoices
    @invoices
  end

  def invoice_items
    @invoice_item_repo
  end

  def transactions
    @transaction_repo
  end

  def customers
    @customer_repo
  end

  def original_items
    item_array = []
    if @item_file == nil
      do_nothing
    else
      item_data = parse_items(@item_file)
      item_data.each do |item_info|
        item_array << Item.new(item_info)
      end
    end
    item_array
  end

  def original_merchants
    merchant_array = []
    if @merchant_file == nil
      do_nothing
    else
      merchant_data = parse_merchants(@merchant_file)
      merchant_data.each do |merchant_info|
        merchant_array << Merchant.new(merchant_info)
      end
    end
    merchant_array
  end

  def original_invoices
    invoice_array = []
    if @invoice_file == nil
      do_nothing
    else
      invoice_data = parse_invoices(@invoice_file)
      invoice_data.each do |invoice_info|
        invoice_array << Invoice.new(invoice_info)
      end
    end
    invoice_array
  end

  def original_invoice_items
    invoice_items = []
    if @invoice_file == nil
      do_nothing
    else
      invoice_items = []
      invoice_item_data = parse_invoice_items(@invoice_file)
      invoice_item_data.each do |invoice_info|
          invoice_items << InvoiceItem.new(invoice_info)
      end
    end
    invoice_items
  end

  def original_customers
    customers = []
    if @customer_file == nil
      do_nothing
    else
      customer_data = parse_customers(@customer_file)
      customer_data.each do |customer_info|
          customers << Customer.new(customer_info)
      end
    end
    customers
  end

  def original_transactions
    transactions = []
    if @transaction_file == nil
      do_nothing
    else
      transaction_data = parse_transactions(@transaction_file)
      transaction_data.each do |transaction_info|
        transactions << Transaction.new(transaction_info)
      end
    end
    transactions
  end

  def analyst
    SalesAnalyst.new(self)
  end

end
