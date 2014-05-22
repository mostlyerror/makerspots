class MakerSpots::ShowFeed

  def self.run
    location_checkins_hash = {}
    locations = MakerSpots::ShowAllLocations.run

    locations[:locations].each do |location|
      checkins = MakerSpots::ShowCheckinsByLocation.run(location.id)
      location_checkins_hash[location] = checkins[:checkins]
    end

    return { success?: false, error: "Error finding locations(Really bad error)" } if location_checkins_hash.empty?

    {
      success?: true,
      locations: location_checkins_hash,
      message: "Return of locations is successful."
    }
  end
end


