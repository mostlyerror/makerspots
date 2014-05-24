class MakerSpots::ShowLocationById

  def self.run(location_id)
    location = MakerSpots.db.get_location(location_id)
    checkins = MakerSpots::ShowCheckinsByLocation.run(location_id)
    checkins = checkins[:checkins]

    return { success?: false, error: "Could not retrive location" } if location.nil?
    {
      success?: true,
      location: location,
      checkins: checkins
    }
  end
end
