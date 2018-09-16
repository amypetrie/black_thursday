class CustomerRepo
  include RepoMethods

  def initialize(data_file, customers)
    @data_file = data_file
    @customers = customers
  end

  def load_repo(transaction_array)
    @transactions = transaction_array.flatten
  end

end
