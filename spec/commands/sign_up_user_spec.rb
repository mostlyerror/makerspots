require 'spec_helper'

describe 'SignUpUser' do

  it 'exists' do
    expect(SignUpUser).to be_a(Class)
  end

  it 'creates a user' do
    user_data = {
      name: 'ben',
      password: 'pizza',
      email: 'ben@ben.com'
    }
    user = MakerSpots::SignUpUser.run(user_data)[:user]
    expect(user.name).to eq('ben')
    expect(user.email).to eq('ben@ben.com')
    expect(user.password).to eq('pizza')
  end

  after(:each) do 
    @db = SQLite3::Database.new "makerspots.db"
    @db.execute <<-SQL
      DELETE from users
    SQL
  end
end
