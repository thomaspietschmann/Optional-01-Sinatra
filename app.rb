require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
# require_relative "./services/scrape_recipes"
require_relative "cookbook"
require_relative "recipe"

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

puts "This is process #{Process.pid}"

csv_file  = File.join(__dir__, 'recipes.csv')
puts csv_file
cookbook = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  hash = {
    name: params[:name],
    author: params[:author],
    rating: params[:rating].to_f
  }
  recipe = Recipe.new(hash)
  cookbook.add_recipe(recipe)
  redirect '/'
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end


# require_relative "view"


# class Controller
#   def initialize(cookbook)
#     @cookbook = cookbook
#     @view = View.new
#   end

#   #  `initialize(cookbook)` takes an instance of the `Cookbook` as an argument.
#   def list
#     recipes = @cookbook.all
#     @view.display(recipes)
#   end

#   def create
#     input = @view.ask_new_recipe
#     add_recipe(input)
#   end

#   def destroy
#     recipes = @cookbook.all
#     index = @view.ask_for_delete(recipes).to_i - 1
#     @cookbook.remove_recipe(index)
#   end

#   def add_recipe(new_recipe)
#     @view.adding(new_recipe)
#     recipe = Recipe.new(new_recipe)
#     @cookbook.add_recipe(recipe)
#   end

#   def import
#     keyword = @view.ask_for_search_keyword
#     scraper = ScrapeRecipes.new(keyword)
#     found_recipes = scraper.call
#     @view.display_for_import(found_recipes)
#     index = @view.ask_for_index_import.to_i - 1
#     new_recipe = scraper.build_recipe_hash(index)
#     add_recipe(new_recipe)
#   end

#   def mark_as_done
#     recipes = @cookbook.all
#     index = @view.ask_for_done(recipes).to_i - 1
#     @cookbook.mark_as_done(index)
#   end
# end
