class MakerSpots::ShowCheckinsByLocation

  def self.run(location_id)
    checkins = MakerSpots.db.get_checkins_by_location(location_id)
    return { success?: false, error: "Error with checkins" } if checkins.first.nil?
    {
      success?: true,
      checkins: checkins,
      message: "All checkins for location id #{location_id} displayed"
    }
  end
end
