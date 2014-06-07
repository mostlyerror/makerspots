require 'spec_helper'

describe 'ShowAllLocations' do
  before(:each) do
    @user = MakerSpots.db.create_user(
      name: "Jacoub",
      email: "jacoub@jayjay.com",
      password: "cats"
      )
  end

  it 'exists' do
    expect(GetUserById).to be_a(Class)
  end

  it 'can retrieve a user by their id' do
    user = MakerSpots::GetUserById.run(@user.id)
    expect(user[:user]).to be_a(User)
    expect(user[:user].name).to eq("Jacoub")
  end

  after(:each) do
    @db = PG.connect(:dbname => 'makerspotsdb')
    @db.exec <<-SQL
      DELETE from users
    SQL

  end
end
