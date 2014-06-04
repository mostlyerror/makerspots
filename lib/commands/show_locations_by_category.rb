class MakerSpots::ShowLocationsByCategory

  def self.run(cat_id)

    locations = MakerSpots.db.get_locations_by_category(cat_id)
    return { success?: false, error: "No locations in this category" } if locations.nil?
    {
      success?: true,
      locations: locations,
    }
  end
end
