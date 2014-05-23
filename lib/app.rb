require 'sinatra'
require 'pry-debugger'
require 'sinatra/reloader'
require_relative 'makerspots.rb'

enable :sessions
set :server, 'thin'

get '/' do
  # Render the home page if the user is signed in
  if session[:user]
    # Get all locations from database
    if MakerSpots.db.get_location(1).id
      @result = MakerSpots::ShowFeed.run
      erb :desktop_layout
    else
      # Databse is empty. Whoops
    end

  # Else send them to sign_in page
  else
    redirect to '/sign_in'
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
    @result = MakerSpots::SignInUser.run(@name, @email)
    # Redirect to root if successful
    if @result[:success?]
      session[:user] = @result[:user]
      redirect '/'
    # Send back to sign_in page if sign in error.
    # Should not happen
    else
      session[:error] = @result[:error]
      redirect '/sign_in'
    end

  # Send back to sign_up page with error if failed signup
  else
    session[:error] = @result[:error]
    redirect '/sign_up'
  end
end

get '/sign_up' do
  erb :sign_up
end


get '/sign_in' do
  erb :sign_in
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
    redirect to '/sign_in'
  end
end

# Test routes. TODO: DELETE

get '/clear_session' do
  session.clear
end

get '/drop_tables' do
  @db = SQLite3::Database.new "makerspots.db"

  @db.execute <<-SQL
    DELETE from users
  SQL

  redirect to '/sign_up'
end

# Helper methods

def name_cleaner(string)
  # Input string (location.name)
  # Output is url friendly version of name. Must match image filename in images/locations
  cleaned = string.gsub(' ', '-')
  cleaned.downcase!
end
