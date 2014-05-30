require 'active_record_tasks'

ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  config.env = 'test'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks

namespace :db do
  require './lib/makerspots.rb'

  task :create do
    @db ||= SQLite3::Database.new "makerspot_test"
  end

  task :drop => [:create] do
    @db.execute("DROP table if exists locations")
    @db.execute("DROP table if exists users")
    @db.execute("DROP table if exists checkins")
  end

  task :create_tables => [:create] do
    puts "worked"
    MakerSpots.db
  end

  task :seed => [:create] do
    require 'json'
    file = open 'location_seed.json'
    json = file.read

    parsed = JSON.parse(json)

    parsed.each do |id,location|
      MakerSpots.db.create_location(
        name: location["name"],
        description: location["description"],
        address: location["address"],
        phone: location["phone"]
        )
    end
    locs = @db.execute("SELECT * FROM locations")
    puts locs
  end
end
