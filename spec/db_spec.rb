require 'spec_helper'

describe 'database' do
  it 'exists' do
    expect(DB).to be_a(Class)
  end

  it 'returns a db' do
    expect(MakerSpots.db).to be_a(DB)
  end

  it "is a singleton" do
    db1 = MakerSpots.db
    db2 = MakerSpots.db
    expect(db1).to be(db2)
  end

  describe 'locations' do
    before(:each) do
      @location = MakerSpots.db.create_location(
        name: "Location",
        description: "Description goes here",
        phone: "972.898.0722",
        address: 'Address here'
        )
    end

    it 'creates a location in the database and returns a location object' do
      expect(@location).to be_a(Location)
      expect(@location.name).to eq 'Location'
      expect(@location.description).to eq 'Description goes here'
      expect(@location.phone).to eq '972.898.0722'
      expect(@location.address).to eq 'Address here'
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from locations
      SQL
    end
  end
end
