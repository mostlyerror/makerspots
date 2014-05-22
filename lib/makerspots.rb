require 'sqlite3'

module MakerSpots
end

require_relative './makerspots/db.rb'
require_relative './makerspots/location.rb'
require_relative './makerspots/user.rb'
require_relative './makerspots/checkin.rb'
require_relative './commands/show_all_locations.rb'
require_relative './commands/show_checkins_by_location.rb'
require_relative './commands/show_feed.rb'
require_relative './commands/sign_up_user.rb'
require_relative 'app.rb'


