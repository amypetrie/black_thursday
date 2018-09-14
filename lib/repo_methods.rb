module RepoMethods

  def find_by_id(id)
    all.inject([]) do |objects, object|
      if object.id == id
        return object
      else
      end
    end
  end

  def delete(id)
    all.delete_if do |object|
      object.id == id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    merchant_id = merchant_id.to_i
    all.find_all do |object|
      object.merchant_id == merchant_id
    end
  end

  def find_highest_object_id
    all.max_by do |object|
      object.id
    end.id.to_i
  end


end
