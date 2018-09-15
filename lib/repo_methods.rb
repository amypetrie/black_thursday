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

  def array_average_value(array)
    sum = array.reduce(0) do |sum, value|
      sum += value
      sum
    end
    avg = (sum / array.length)
  end

  def standard_deviation_step_one(array, average)
    array.map do |value|
      (value - average)**2
    end
  end

  def standard_deviation_step_two(step_one_value_array)
    step_one_value_array.reduce(0) do |num, value|
      num += value
      num
    end
  end

  def standard_deviation_step_three(step_two_value, step_one_array, deviation_type)
    if deviation_type.to_s == "sample"
      denominator = step_one_array.length - 1
    elsif deviation_type.to_s == "population"
      denominator = step_one_array.length
    end
    value = (step_two_value / denominator)
  end

  def standard_deviation_final_step(step_three_value)
    Math.sqrt(step_three_value).round(2)
  end

  def find_standard_deviation(array, deviation_type)
    average = average_items_per_merchant
    step_one_array = standard_deviation_step_one(array, average)
    step_two_value = standard_deviation_step_two(step_one_array)
    step_three_value = standard_deviation_step_three(step_two_value, step_one_array, deviation_type)
    standard_deviation = standard_deviation_final_step(step_three_value)
  end

end
