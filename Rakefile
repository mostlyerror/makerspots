
namespace :db do
  require './lib/makerspots.rb'

  task :create do
    @db ||= SQLite3::Database.new "makerspots.db"
  end

  task :drop => [:create] do
    @db.execute("DROP table if exists locations")
    @db.execute("DROP table if exists users")
    @db.execute("DROP table if exists checkins")
  end

  task :seed => [:drop] do
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
