require 'spec_helper'

describe 'GetGravatar' do

  it 'exists' do
    expect(GetGravatar).to be_a(Class)
  end

  describe 'run' do
    it 'returns a hash with gravatar img url' do
      img_url = "http://www.gravatar.com/avatar/52bad6c2e5375f389955d89d7f559a7b.png?s=80&d=mm"
      expect(MakerSpots::GetGravatar.run('benjamintpoon@gmail.com')[:gravatar]).to eq(img_url)
    end

    it 'returns a hash w/ img url if given a default' do
      sloth = "http://www.thatcutesite.com/uploads/2009/09/baby_sloth_box.jpg"
      expected = "http://www.gravatar.com/avatar/a86a735eb78567e14fa33aa8b7da9952.png?s=80&d=http://www.thatcutesite.com/uploads/2009/09/baby_sloth_box.jpg"
      expect(MakerSpots::GetGravatar.run('pp@poopoo.com', default: sloth)[:gravatar]).to eq(expected)
    end
  end
end
