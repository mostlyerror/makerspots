require 'spec_helper'

describe 'SignInUser' do
  before(:each) do
    @data = {
      name: 'lionel',
      password: 'rich',
      email: 'lionel@rich.com'
    }
    @user = MakerSpots.db.create_user(@data)
  end
  describe 'with valid credentials' do
    it 'returns a successful results hash' do

      result = MakerSpots::SignInUser.run(@user.email, @user.password)

      expect(result[:success?]).to eq true
      expect(result[:user]).to be_a(User)
      expect(result[:user].id).to eq @user.id
      expect(result.has_key?(:gravatar)).to eq true
    end
  end

  describe 'with invalid credentials' do
    it 'returns an error message' do
      result = MakerSpots::SignInUser.run('lionel', 'notreal')

      expect(result[:success?]).to eq false
      expect(result[:error]).to eq 'Email does not match our records'
      expect(result[:user]).to eq nil
    end
  end

  after(:each) do
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from users
    SQL
  end
end
