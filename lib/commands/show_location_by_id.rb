class MakerSpots::ShowLocationById

  def self.run(location_id)
    location = MakerSpots.db.get_location(location_id)
    return { success?: false, error: "Could not retrive location" } if location.nil?
    {
      success?: true,
      location: location
    }
  end
end
