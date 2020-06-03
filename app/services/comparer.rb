class Comparer
  attr_accessor :criteria, :value 
  attr_reader :result, :index

  def initialize(criteria, value)
    @criteria = criteria
    @value = value
  end

  def run
    @result = [*0..criteria.count-1].map{ |n|
      criteria[n] == value[n]
    }
    print_amount
    @result.include?(false)? false : true
  end

  private
  def print_amount
    counter = 0
      while @result[counter]
        counter += 1
      end
    @index = counter - 1
  end

end