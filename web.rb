require 'sinatra'
require 'data_mapper'

# ---------------------------------------------------------
# Database Stuff
# http://datamapper.org/docs/properties.html
#

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

#class Artist
#  include DataMapper::Resource
#  property :id, Serial
#  property :first_name, String
#  property :last_name, String

#  has n, :songs # artist.songs
#end

#class Person
#  include DataMapper::Resource
#  property :id, Serial
#  property :name, String
#  property :age, Integer
#  property :created_at, DateTime
#end

#class Song
  #include DataMapper::Resource
  #property :id, Serial
  #property :name, String
  #property :genre, String
  #property :duration_in_seconds, Integer

 # belongs_to :artist # artist_id, reference Artist, so you can do @artist.song
#end
#class Station
  #include DataMapper::Resource
  #property :id, Serial
  #propery :name, String
 # propery :channel, String
#  propery :popularity, Integer

#  belongs_to :artist
#end
#ataMapper.finalize
#
#Song.auto_upgrade!
#Artist.auto_upgrade!
#Person.auto_upgrade!
#Station.auto_upgrade! 




class Drink
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  belongs_to :Company #Ability to reference to company.drink
  has n, :Ingredient # Ability to reference as @drink.ingreidents
end
class Company
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :popularity, Integer
  has n, :Drink
  # property :Bankrupted, Boolean
end
class Ingredient
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :color, String
  property :Grams_Of_Sugar, Integer
  belongs_to :Drink
end


#Finalization and AutoUpgrading
DataMapper.finalize

Drink.auto_upgrade!
Company.auto_upgrade!
Ingredient.auto_upgrade!


# ---------------------------------------------------------


# ---------------------------------------------------------
# Routes
#

#get '/' do
#  @people = Person.all
#  erb :index, locals: { people: @people }
#end

#get '/new' do
#  erb :new
#end

#post '/create' do
#  @person = Person.create(params[:person]);
#  redirect to("/#{@person.name}")
#end

#get '/:name' do
#  if @person = Person.first(name: params[:name]);
#    erb :show, locals: { person: @person }
#  else
#    'Invalid'
#  end
#end

# ---------------------------------------------------------
# Drinks
# ---------------------------------------------------------
get '/' do
  erb :index, locals: { drink: Drink.all}
end

get '/new' do
  @ingredient = Ingredient.all
  @drink = Drink.all
  erb :new
end

post '/create' do
  @drink = Drink.create(params[:drink])
  redirect to("/#{@drink.name}")
end

get 'drinks/:id' do                                           #  /==/   /==\  \    /\    /  /==/
  if @drink = Drink.first(id: params[:id])
      if @company = Company.first(id: params[:id])                  # /--/   /----\  \  /  \  /  /--/
        erb :'drinks/show', locals: { drink: @drink, company: @company }              #/   \  /      \  \/    \/  /   \
  end
end


# ---------------------------------------------------------
# Companies
# ---------------------------------------------------------
get '/companies/new' do
  @companies = Company.all
  @drinks = Drink.all
  erb :'companies/new'
end

post '/companies' do
  # params = { artist: { first_name: "DEF", last_name: "GEH" } }
  # Artist.create({first_name: "DEF", last_name: "GEH"})
  @ompany = Company.create(params[:company])
  redirect to("/companies/#{@company.id}")
end

get '/companies/:id' do
  if @company = Company.first(id: params[:id])
    erb :'companies/show', locals: { company: @company }
  end
end

# ---------------------------------------------------------
# Ingredients
# ---------------------------------------------------------
get '/ingredients/new' do
  @ingredients = Ingredient.all
  erb :'/ingredients/new', locals: { ingredients: @ingredients }
end

post '/ingredients' do
  @ingredients = Ingredient.create(params[:ingredient])
  redirect to("/ingredients/#{@ingredients.id}")
end
  
get '/ingredients/:id' do
  if @ingredients = Ingredient.first(id: params[:id])
    erb :'ingredients/show', locals: { ingredients: @ingredients }
    end
  end
end