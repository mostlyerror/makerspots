require 'spec_helper'

describe 'database' do
  it 'exists' do
    expect(SQLiteDatabase).to be_a(Class)
  end

  it 'returns a db' do
    expect(MakerSpots.db).to be_a(SQLiteDatabase)
  end

  it "is a singleton" do
    db1 = MakerSpots.db
    db2 = MakerSpots.db
    expect(db1).to be(db2)
  end

  describe 'locations' do
    before(:each) do
      @category = MakerSpots.db.create_category(
      name: "Category"
      )
      @location = MakerSpots.db.create_location(
        {name: "Location",
        description: "Description goes here",
        phone: "972.898.0722",
        address: 'Address here'},
        [@category.id]
        )
    end

    it 'creates a location in the database and returns a location object' do
      expect(@location).to be_a(Location)
      expect(@location.name).to eq 'Location'
      expect(@location.description).to eq 'Description goes here'
      expect(@location.phone).to eq '972.898.0722'
      expect(@location.address).to eq 'Address here'
    end

    it 'gets a location object by id' do
      location = MakerSpots.db.get_location(@location.id)

      expect(location).to be_a(Location)
      expect(location.id).to eq @location.id
      expect(location.name).to eq @location.name
      expect(location.description).to eq @location.description
      expect(location.phone).to eq @location.phone
      expect(location.address).to eq @location.address
    end

    it 'gets all locations in database' do
      location2 =
        MakerSpots.db.create_location(
                {name: "Location 2",
                description: "Description goes here too",
                phone: "972.898.0711",
                address: 'An Address'},
                [@category.id]
                )
      location3 =
        MakerSpots.db.create_location(
                {name: "Location 3",
                description: "Description goes here also",
                phone: "972.898.0733",
                address: 'An Address too'},
                [@category.id]
                )
      locations = MakerSpots.db.get_all_locations

      expect(locations).to be_a(Array)
      expect(locations.length).to eq 3

      # Location objects populate correct attributes
      location = locations.first
      expect(locations.first).to be_a(Location)
      expect(location.name).to eq @location.name
      expect(location.id).to eq @location.id
      expect(location.description).to eq @location.description
      expect(location.phone).to eq @location.phone
      expect(location.address).to eq @location.address
    end

    it 'gets locations by category' do
      location2 =
        MakerSpots.db.create_location(
                {
                  name: "Location 2",
                  description: "Description goes here too",
                  phone: "972.898.0711",
                  address: 'An Address'
                },[@category.id]
                )
      locations = MakerSpots.db.get_locations_by_category(@category.id)
      expect(locations.length).to eq 2
      expect(locations.first).to be_a(Location)
      expect(locations.first.name).to eq "Location"
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from locations
      SQL
      @db.execute <<-SQL
        DELETE from category_locations
      SQL
      @db.execute <<-SQL
        DELETE from categories
      SQL
    end
  end

  describe 'users' do
    before(:each) do
      @user = MakerSpots.db.create_user(
        name: "david",
        email: 'david@email.com',
        password: 'password'
      )
    end

    it 'creates a user and returns a User object' do
      expect(@user).to be_a(User)
      expect(@user.name).to eq 'david'
      expect(@user.email).to eq 'david@email.com'
      expect(@user.password).to eq 'password'
    end

    it 'gets a user object from database by id' do
      user = MakerSpots.db.get_user_by_id(@user.id)

      expect(user).to be_a(User)
      expect(user.id).to eq @user.id
      expect(user.name).to eq @user.name
      expect(user.email).to eq @user.email
      expect(user.password).to eq @user.password
    end

    it 'gets a user object from database by email' do
      user = MakerSpots.db.get_user_by_email(@user.email)

      expect(user).to be_a(User)
      expect(user.id).to eq @user.id
      expect(user.name).to eq @user.name
      expect(user.email).to eq @user.email
      expect(user.password).to eq @user.password
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from users
      SQL
    end
  end

  describe 'checkins' do
    before(:each) do
      @user = MakerSpots.db.create_user(
        name: "david",
        email: 'david@email.com',
        password: 'password'
      )
      @location = MakerSpots.db.create_location(
        name: "Location",
        description: "Description goes here",
        phone: "972.898.0722",
        address: 'Address here'
      )
      @checkin = MakerSpots.db.create_checkin(
        location_id: @location.id,
        user_id: @user.id,
      )
    end

    it 'creates a checkin object associated with a user and location id' do
      expect(@checkin).to be_a(Checkin)
      expect(@checkin.location_id).to eq @location.id
      expect(@checkin.user_id).to eq @user.id
      expect(@checkin.checked_in).to eq true
      expect(@checkin.created_at).not_to eq nil
    end

    it 'retrieves a checkin object by user id' do
      checkin = MakerSpots.db.get_checkins_by_user(@user.id)

      expect(checkin).to be_a(Checkin)
      expect(checkin.id).to eq @checkin.id
      expect(checkin.location_id).to eq @checkin.location_id
      expect(checkin.user_id).to eq @checkin.user_id
      expect(checkin.checked_in).to eq @checkin.checked_in
    end

    it 'retrieves all checkins for a location' do
      checkin2 =
        MakerSpots.db.create_checkin(
          location_id: @location.id,
          user_id: @user.id
        )
      checkin3 =
        MakerSpots.db.create_checkin(
          location_id: @location.id,
          user_id: @user.id
        )
      checkin4 =
        MakerSpots.db.create_checkin(
          location_id: @location.id.to_i + 1,
          user_id: @user.id
        )
      checkin5 =
        MakerSpots.db.create_checkin(
          location_id: @location.id,
          user_id: @user.id
        )

      # Set checked_in to false
      checkin5 = MakerSpots.db.checkout(@user.id)

      checkins = MakerSpots.db.get_checkins_by_location(@location.id)

      expect(checkins).to be_a(Array)

      # Should only include checkins with matching location id that are active
      expect(checkins.length).to eq 3
      checkin = checkins.first
      expect(checkin.location_id).to eq @location.id
      expect(checkin.user_id).to eq @user.id
      expect(checkin.checked_in).to eq @checkin.checked_in
    end

    it 'updates checkin.checked_in by id' do
      checkin = MakerSpots.db.checkout(@user.id)

      expect(checkin).to be_a(Checkin)
      expect(checkin.id).to eq @checkin.id
      expect(checkin.checked_in).to eq false
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from users
      SQL
      @db.execute <<-SQL
        DELETE from locations
      SQL
      @db.execute <<-SQL
        DELETE from checkins
      SQL
    end
  end

  describe 'categories' do
    before do

    end

    it 'exists' do
      category = MakerSpots.db.create_category(name: "Coffee")

      expect(category).to be_a(Category)
      expect(category.name).to eq "Coffee"
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from categories
      SQL
    end
  end
end
