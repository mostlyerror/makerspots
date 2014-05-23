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
    end
  end

  describe 'get_gravatar_img' do
    it 'returns a gravatar img url' do
      data = {name: 'benjamin', email: 'benjamintpoon@gmail.com', password: 'doge'}
      grav_user = MakerSpots.db.create_user(data)
      img_url = "http://www.gravatar.com/avatar/52bad6c2e5375f389955d89d7f559a7b.png?s=100&d=mm"
      expect(MakerSpots::SignInUser.get_gravatar_img(grav_user.email)).to eq(img_url)
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
