# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__DIR__)
end

puts "This is process #{Process.pid}"

csv_file = File.join(__dir__, 'recipes.csv')
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

get '/delete' do
  @recipes = cookbook.all
  erb :delete
end

post '/delete' do
  choice = params[:number].to_i - 1
  cookbook.remove_recipe(choice)
  redirect '/'
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
