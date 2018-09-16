require_relative '../lib/repo_methods'

class ItemRepo
  include RepoMethods

  attr_reader :data_file,
              :items

  def initialize(data_file, items)
    @data_file = data_file
    @items = items
  end

  def load_repo(item_array)
    @items = item_array.flatten
  end

  def all
    @items
  end

  def find_by_name(name)
    @items.inject([]) do |items, item|
      if item.name.downcase == name.downcase
        return item
      else
      end
    end
  end

  def find_all_with_description(description)
    @items.find_all do |item|
      item.description.downcase.include? description.downcase
    end
  end

  def find_all_by_price(price)
    @items.find_all do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    @items.find_all do |item|
      (item.unit_price >= range.begin) && (item.unit_price <= range.end)
    end
  end

  def find_highest_item_id
    find_highest_object_id
  end

  def create(attributes)
    item = Item.new(attributes)
    item.create_id(find_highest_item_id + 1)
    @items << item
    item
  end

  def update(id, attributes)
    item = find_by_id(id)
    if item == nil
      do_nothing
    else
      item.name = attributes[:name] unless attributes[:name] == nil
      item.description = attributes[:description] unless attributes[:description] == nil
      item.unit_price = attributes[:unit_price] unless attributes[:unit_price] == nil
      time = Time.now
      item.updated_at = Time.now
    end
    item
  end

end
