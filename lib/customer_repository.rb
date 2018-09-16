require_relative "../lib/repo_methods"

class CustomerRepo

  include RepoMethods

  def initialize(data_file, customers)
    @data_file = data_file
    @customers = customers
  end

  def load_repo(transaction_array)
    @customers = transaction_array.flatten
  end

  def all
    @customers
  end

  def find_all_by_first_name(first_name)
    @customers.find_all do |customer|
    customer.first_name.downcase.include? first_name.downcase
  end
end

  def find_all_by_last_name(last_name)
    @customers.find_all do |customer|
      customer.last_name.downcase.include? last_name.downcase
    end
  end

  def create(attributes)
    attributes[:id] = (find_highest_object_id + 1)
    attributes[:created_at] = Time.now
    attributes[:updated_at] = Time.now
    customer = Customer.new(attributes)
    @customers << customer
    customer
  end

  def update(id, attributes)
    customer = find_by_id(id)
    if customer == nil
      do_nothing
    else
      customer.first_name = attributes[:first_name] unless attributes[:first_name] == nil
      customer.last_name = attributes[:last_name] unless attributes[:last_name] == nil
      customer.updated_at = Time.now
    end
  end

end
