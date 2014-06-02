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

  describe 'checking a user' do
    it 'returns a successful results hash' do
      result = MakerSpots::CheckOutUser.run(@user.id)
      expect(result[:success?]).to eq true
      expect(result[:message]).to eq 'Checked out successfully'
      check_in = MakerSpots.db.get_checkins_by_user(@user.id)
      expect(check_in[:error]).should be_true
    end
  end

  after(:each) do
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from users
    SQL
    @db.execute <<-SQL
      DELETE from checkins
    SQL
    @db.execute <<-SQL
      DELETE from locations
    SQL
  end
end
