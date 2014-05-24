require 'spec_helper'

describe 'CheckinUser' do
  before(:each) do
    @user = MakerSpots.db.create_user(
      name: 'lionel',
      password: 'rich',
      email: 'lionel@rich.com'
    )
    @location = MakerSpots.db.create_location(
      name: "Wholly Cow Burgers",
      description: "Wholly Cow Burgers welcomes you to stop by and try out our Local Grass-Fed Beef Burgers, Philly Cheeseteaks, Reubens, Chili, and More!  Featuring Local Organic Pasture Raised  Hormone & Chemical-Free Grass Fed Beef Along with Locally-Grown Organic Produce when in Season.",
      phone: "5124250811",
      address: '619 Congress Ave'
      )
  end
  describe 'when no check in exists for user' do
    it 'returns a successful results hash' do
      result = MakerSpots::CheckinUser.run(@user.id, @location.id)
      expect(result[:success?]).to eq true
      expect(result[:checkin]).to be_a(Checkin)
      expect(result[:checkin].location_id).to eq @location.id
      expect(result[:checkin].user_id).to eq @user.id
    end
  end

  describe 'when an active checkin exists for user' do
    it 'sets existing_checkin.checked_in to false' do
      checkin =
        MakerSpots.db.create_checkin(
          location_id: @location.id,
          user_id: @user.id
        )
      result = MakerSpots::CheckinUser.run(@user.id, @location.id)

      # Returns the new Checkin
      expect(result[:checkin]).to be_a(Checkin)
      expect(result[:checkin].user_id).to eq @user.id
      expect(result[:checkin].id).not_to eq checkin.id
    end
  end

  after(:each) do
    @db = PG.connect( dbname: 'makerspotsdb' )
    @db.exec <<-SQL
      DELETE from users
    SQL
    @db.exec <<-SQL
      DELETE from checkins
    SQL
    @db.exec <<-SQL
      DELETE from locations
    SQL
  end
end
