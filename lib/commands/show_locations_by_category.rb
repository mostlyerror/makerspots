class MakerSpots::ShowLocationsByCategory

  def self.run(cat_id)

    locations = MakerSpots.db.get_locations_by_category(cat_id)
    if locations.include?(:error)
      return { success?: false, error: "No results found" }
    end
    {
      success?: true,
      locations: locations,
    }
  end
end
