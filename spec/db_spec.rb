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

    it 'gets a location object by id' do
      location = MakerSpots.db.get_location(@location.id)

      expect(location).to be_a(Location)
      expect(location.id).to eq @location.id
      expect(location.name).to eq @location.name
      expect(location.description).to eq @location.description
      expect(location.phone).to eq @location.phone
      expect(location.address).to eq @location.address
    end

    after(:each) do
      @db = SQLite3::Database.new "makerspots.db"
      @db.execute <<-SQL
        DELETE from locations
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
      user = MakerSpots.db.get_user(@user.id)

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
      expect(@checkin.checked_in).to eq 1
      # TODO: test the datetime is assigned correctly.
      expect(@checkin.created_at).not_to eq nil
    end

    it 'retrieves a checkin object by checkin id' do
      checkin = MakerSpots.db.get_checkin(@checkin.id)

      expect(checkin).to be_a(Checkin)
      expect(checkin.id).to eq @checkin.id
      expect(checkin.location_id).to eq @checkin.location_id
      expect(checkin.user_id).to eq @checkin.user_id
      expect(checkin.checked_in).to eq @checkin.checked_in
      expect(checkin.created_at).to eq @checkin.created_at
    end

    it 'updates checkin.checked_in by id' do
      checkin = MakerSpots.db.check_out(@checkin.id)

      expect(checkin).to be_a(Checkin)
      expect(checkin.id).to eq @checkin.id
      expect(checkin.checked_in).to eq 0
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
end
