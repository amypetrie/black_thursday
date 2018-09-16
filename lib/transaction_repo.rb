require_relative '../lib/repo_methods'

class TransactionRepo
  include RepoMethods

  attr_reader :data_file,
              :transactions

  def initialize(data_file, transactions)
    @data_file = data_file
    @transactions = transactions
  end

  def all
    @transactions
  end

  def load_repo(transaction_array)
    @transactions = transaction_array.flatten
  end

  def create(attributes)
    attributes[:id] = (find_highest_object_id + 1)
    attributes[:created_at] = Time.now
    attributes[:updated_at] = Time.now
    transaction = Transaction.new(attributes)
    @transactions << transaction
    transaction
  end

  def update(id, attributes)
    transaction = find_by_id(id)
    if transaction == nil
      do_nothing
    else
      transaction.credit_card_number = attributes[:credit_card_number] unless attributes[:credit_card_number] == nil
      transaction.credit_card_expiration_date = attributes[:credit_card_expiration_date] unless attributes[:credit_card_expiration_date] == nil
      transaction.result = attributes[:result] unless attributes[:result] == nil
      transaction.updated_at = Time.now
    end
  end

end
