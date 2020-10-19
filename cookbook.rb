# when we iterate over an array of arrays we can "explode" the array and directly access its values

# array.each do |name, description|
#   puts...


require_relative "recipe"
require "csv"


class Cookbook
  def initialize(csv_file_path)
    @csv_file = csv_file_path
    @recipes = []
    parse_csv
  end

  def all
    return @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    write_csv
  end

  def mark_as_done(index)
    @recipes[index].done!
    write_csv
  end


  private

  def parse_csv
    CSV.foreach(@csv_file) do |row|
      recipe = Recipe.new({ name: row[0], author: row[1], rating: row[2], done: row[3] })
      @recipes << recipe
    end
  end

  def write_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    # filepath = @csv_file
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.author, recipe.rating, recipe.done]
      end
    end
  end
end
