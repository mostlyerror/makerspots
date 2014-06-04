require 'spec_helper'

describe 'ShowLocationsByCategory' do
  before(:each) do
    @location1 = MakerSpots.db.create_location(
      name: "Wholly Cow Burgers",
      description: "Wholly Cow Burgers welcomes you to stop by and try out our Local Grass-Fed Beef Burgers, Philly Cheeseteaks, Reubens, Chili, and More!  Featuring Local Organic Pasture Raised  Hormone & Chemical-Free Grass Fed Beef Along with Locally-Grown Organic Produce when in Season.",
      phone: "5124250811",
      address: '619 Congress Ave',
      category_id: 1
      )
    @location2 = MakerSpots.db.create_location(
      name: "Royal Blue Grocery",
      description: "Royal Blue Grocery is a compact urban market with several locations in the heart of downtown Austin, Texas. The stores were created specifically for Austin and the people who live, work, and play downtown. Each store is different from the next, tailored to the neighborhood it serves and the people who frequent it every day. Royal Blue offers a little bit of everything, from the freshly prepared grab-and-go offerings, to conventional grocery and convenience items.
",
      phone: "5124695888",
      address: '609 Congress Ave',
      category_id: 1
      )
  end

  it 'exists' do
    expect(ShowLocationsByCategory).to be_a(Class)
  end

  it 'returns an array of locations in a category' do
    result = MakerSpots::ShowLocationsByCategory.run(1)

    expect(result[:success?]).to eq true
    expect(result[:locations].first).to be_a(Location)
  end

  it 'returns an error if no locations exist in a category' do
    result = MakerSpots::ShowLocationsByCategory.run(2)

    expect(result[:success?]).to eq false
    expect(result).to include(:error)
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
