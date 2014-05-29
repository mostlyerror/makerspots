require 'spec_helper'

describe 'ShowLocationById' do


    @location1 = MakerSpots.db.create_location(
      name: "Wholly Cow Burgers",
      description: "Wholly Cow Burgers welcomes you to stop by and try out our Local Grass-Fed Beef Burgers, Philly Cheeseteaks, Reubens, Chili, and More!  Featuring Local Organic Pasture Raised  Hormone & Chemical-Free Grass Fed Beef Along with Locally-Grown Organic Produce when in Season.",
      phone: "5124250811",
      address: '619 Congress Ave'
      )
    @checkin =
        MakerSpots.db.create_checkin(
          location_id: @location1.id,
          user_id: 1
        )

  it 'exists' do
    expect(ShowLocationById).to be_a(Class)
  end

  it 'returns a location object' do
    result = MakerSpots::ShowLocationById.run(1)
    expect(result[:location]).to be_a(Location)
  end

  it 'returns an array of active checkins' do
    result = MakerSpots::ShowLocationById.run(1)
    expect(result[:checkins]).to be_a(Array)
  end

  after(:each) do
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from locations
    SQL
    @db.execute <<-SQL
      DELETE from checkins
    SQL
  end

end
