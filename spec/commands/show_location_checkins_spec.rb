require 'spec_helper'

describe 'ShowAllLocations' do
  before(:each) do
    @location1 = MakerSpots.db.create_location(
      name: "Wholly Cow Burgers",
      description: "Wholly Cow Burgers welcomes you to stop by and try out our Local Grass-Fed Beef Burgers, Philly Cheeseteaks, Reubens, Chili, and More!  Featuring Local Organic Pasture Raised  Hormone & Chemical-Free Grass Fed Beef Along with Locally-Grown Organic Produce when in Season.",
      phone: "5124250811",
      address: '619 Congress Ave'
      )
    @location2 = MakerSpots.db.create_location(
      name: "Royal Blue Grocery",
      description: "Royal Blue Grocery is a compact urban market with several locations in the heart of downtown Austin, Texas. The stores were created specifically for Austin and the people who live, work, and play downtown. Each store is different from the next, tailored to the neighborhood it serves and the people who frequent it every day. Royal Blue offers a little bit of everything, from the freshly prepared grab-and-go offerings, to conventional grocery and convenience items.
",
      phone: "5124695888",
      address: '609 Congress Ave'
      )

  end

  it 'exists' do
    expect(ShowLocationCheckins).to be_a(Class)
  end

  it 'returns success' do
    expect(MakerSpots::ShowAllLocations.run[:success?]).to eq(true)
  end

  it 'returns an array of location objects' do
    expect(MakerSpots::ShowAllLocations.run[:locations][0]).to be_a(Location)
  end

  it 'returns an error when there are no locations' do
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from locations
    SQL
    expect(MakerSpots::ShowAllLocations.run[:success?]).to eq(false)
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
