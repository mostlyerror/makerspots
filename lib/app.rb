require 'sinatra'
require 'pry-debugger'
require 'sinatra/reloader'
require_relative 'makerspots.rb'

set :bind, '0.0.0.0'

enable :sessions

get '/' do
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
    redirect to '/landing'
  end
# Signing in and signing up routing
end

