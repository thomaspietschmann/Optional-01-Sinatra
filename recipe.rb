class Recipe
  attr_reader :name, :author, :rating, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @author = attributes[:author]
    @rating = attributes[:rating].to_f.round(1)
    @done = attributes[:done].to_i
  end

  def done!
    @done = 1
  end
end
