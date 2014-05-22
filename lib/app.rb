require 'sinatra'
require 'pry-debugger'
require_relative 'app.rb'

set :bind, '0.0.0.0'

get '/' do
  erb :desktop_layout
end

