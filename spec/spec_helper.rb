require 'pry'
require './lib/makerspots.rb'
require './lib/app.rb'
require 'rspec'
require 'rack/test'
require 'capybara/rspec'
include MakerSpots

ENV['RACK_ENV'] = 'test'

#Mixin for testing sinatra
# module RSpecMixin
#   include Rack::Test::Methods
#   def app
#     Sinatra::Application
#   end
#   Capybara.app = Sinatra::Application.new
# end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus
  #config.include RSpecMixin
  config.include Capybara::DSL

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

Capybara.configure do |config|
  #config.include RSpecMixin
end
