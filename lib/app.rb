require 'sinatra'
require 'pry-debugger'

set :bind, '0.0.0.0'

get '/' do
  erb :desktop_layout
end

