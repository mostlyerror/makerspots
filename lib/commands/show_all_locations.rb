class MakerSpots::ShowAllLocations

  def self.run
    locations = MakerSpots.db.get_all_locations
    return { success?: false, error: "No locations found" } if locations.empty?
    {
      success?: true,
      locations: locations,
      message: "All locations found"
    }
  end

end
