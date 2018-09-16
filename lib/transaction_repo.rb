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

end
