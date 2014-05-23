class MakerSpots::AddNewLocation

  def self.run(data)
    location = MakerSpots.db.create_location(data)
    return { success?: false, error: "Error adding location to the database" } if location.nil?
    {
      success?: true,
      location: location
    }
  end

end
