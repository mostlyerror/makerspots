require 'spec_helper'

describe 'AddNewLocation' do

  it 'exists' do
    expect(AddNewLocation).to be_a(Class)
  end

  it 'can add a new location to the database' do
    data = {
      name: "Wholly Cow Burgers",
      description: "Wholly Cow Burgers welcomes you to stop by and try out our Local Grass-Fed Beef Burgers, Philly Cheeseteaks, Reubens, Chili, and More!  Featuring Local Organic Pasture Raised  Hormone & Chemical-Free Grass Fed Beef Along with Locally-Grown Organic Produce when in Season.",
      phone: "5124250811",
      address: '619 Congress Ave'
    }
    expect(MakerSpots::AddNewLocation.run(data)[:success?]).to eq(true)
    expect(MakerSpots::AddNewLocation.run(data)[:location]).to be_a(Location)
  end

  after(:each) do
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from locations
    SQL
  end
end
