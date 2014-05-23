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
      img_url = "http://www.gravatar.com/avatar/52bad6c2e5375f389955d89d7f559a7b.png?s=80&d=mm"
      expect(MakerSpots::SignInUser.get_gravatar_img('benjamintpoon@gmail.com')).to eq(img_url)
    end

    it 'returns an img url if given a default' do
      sloth = "http://www.thatcutesite.com/uploads/2009/09/baby_sloth_box.jpg"
      expected = "http://www.gravatar.com/avatar/a86a735eb78567e14fa33aa8b7da9952.png?s=80&d=http://www.thatcutesite.com/uploads/2009/09/baby_sloth_box.jpg"
      expect(MakerSpots::SignInUser.get_gravatar_img('pp@poopoo.com', default: sloth)).to eq(expected)
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
