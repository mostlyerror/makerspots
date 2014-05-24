require 'spec_helper'

describe 'ShowLocationById' do

  it 'exists' do
    expect(ShowLocationById).to be_a(Class)
  end

  it 'returns a location object' do
    result = MakerSpots::ShowLocationById.run(1)
    expect(result[:location]).to be_a(Location)
  end

end
