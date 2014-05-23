require 'sinatra'
require 'pry-debugger'
require 'sinatra/reloader'
require_relative 'makerspots.rb'

enable :sessions

set :bind, "0.0.0.0"

get '/' do
  # Render the home page if the user is signed in
  if session[:user]
    # Get all locations from database
    @locations = MakerSpots::ShowFeed.run
    erb :desktop_layout
  else
    redirect to '/landing'
  end
end


# Sign up workflow
post '/' do
  @name = params[:name]
  @email = params[:email]
  @password = params[:password]
  @result = MakerSpots::SignUpUser.run(name: @name, email: @email, password: @password)
  # Sign in user automatically if successful signup
  if @result[:success?]
    @result = MakerSpots::SignInUser.run(@email, @password)
    # Redirect to root if successful
    if @result[:success?]
      session[:user] = @result[:user]
      redirect '/'
    # Send back to sign_in page if sign in error.
    # Should not happen
    else
      session[:error] = @result[:error]
      redirect '/landing'
    end

  # Send back to sign_up page with error if failed signup
  else
    session[:error] = @result[:error]
    session[:signup_error] = true
    redirect '/landing'
  end
end

get '/landing' do
  erb :landing, :layout => :landing_layout
end

post '/new_user_session' do
  @email = params[:email]
  @password = params[:password]
  @result = MakerSpots::SignInUser.run(@email, @password)
  if @result[:success?]
    session[:user] = @result[:user]
    redirect to '/'
  else
    session[:error] = @result[:error]
    redirect to '/landing'
  end
end

# Test routes. TODO: DELETE

get '/sign_out' do
  session.clear
  redirect to '/landing'
end

get '/drop_tables' do
  @db = SQLite3::Database.new "makerspots.db"

  @db.execute <<-SQL
    DELETE from users
  SQL

  @db.execute <<-SQL
    DELETE from users
  SQL

  redirect to '/landing'
end

# Rout for desktop javascript experiment

get '/location_list' do
  @result = MakerSpots::ShowAllLocations.run
  erb :desktop_layout
end

# Admin Location Log

get '/add_location' do
  erb :add_location
end

post '/add_location' do
  data = {
    name: params[:name],
    description: params[:description],
    phone: params[:phone],
    address: params[:address]
  }
  location = MakerSpots::AddNewLocation.run(data)
  redirect to '/add_location'
end

# Helper

def name_cleaner(string)
  # Input string (location.name)
  # Output is url friendly version of name. Must match image filename in images/locations
  cleaned = string.gsub(' ', '-')
  cleaned.downcase!
end
