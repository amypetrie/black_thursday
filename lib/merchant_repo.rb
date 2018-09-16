require_relative '../lib/repo_methods'

class MerchantRepo
  include RepoMethods

  attr_reader :merchants,
              :data_file

  def initialize(data_file, merchants)
    @data_file = data_file
    @merchants = merchants
  end

  def load_repo(merchant_array)
    @merchants = merchant_array.flatten
  end

  def all
    @merchants
  end

  def find_by_name(name)
    @merchants.find do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    @merchants.find_all do |merchant|
      merchant.name.downcase.include? name.downcase
    end
  end

  def find_highest_merchant_id
    find_highest_object_id
  end

  def create(attributes)
    attributes[:id] = (find_highest_object_id + 1)
    attributes[:created_at] = Time.now
    attributes[:updated_at] = Time.now
    merchant = Merchant.new(attributes)
    @merchants << merchant
    merchant
  end

  def update(id, attributes)
    merchant = find_by_id(id)
    if merchant == nil
      do_nothing
    else
      merchant.name = attributes[:name]
      merchant.change_updated_at
    end
  end

end
