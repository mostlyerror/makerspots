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
require_relative './commands/sign_in_user.rb'
require_relative './commands/check_in_user.rb'
require_relative './commands/checkout_user.rb'
require_relative './commands/add_new_location.rb'
require_relative './commands/get_gravatar_img.rb'
require_relative './commands/get_user_by_id.rb'
require_relative 'app.rb'


