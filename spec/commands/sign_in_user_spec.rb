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

      result = MakerSpots::SignInUser.run(@user.name, @user.password)

      expect(result[:success?]).to eq true
      expect(result[:user]).to be_a(User)
      expect(result[:user].id).to eq @user.id
    end
  end

  describe 'with invalid credentials' do
    it 'returns an error message' do
      result = MakerSpots::SignInUser.run('lionel', 'notreal')

      expect(result[:success?]).to eq false
      expect(result[:error]).to eq 'Username and password do not match our records'
      expect(result[:user]).to eq nil
    end
  end
end
