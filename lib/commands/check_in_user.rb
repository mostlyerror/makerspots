class MakerSpots::CheckinUser

  def self.run(user_id, loc_id)

  	checkins = MakerSpots.db.get_checkins_by_user(user_id)
  	MakerSpots.db.checkout(checkins.id)
  	new_checkin = MakerSpots.db.create_checkin(location_id: loc_id, user_id: user_id)
  	{
  		success?: true,
  		checkin: new_checkin,
  		message: "checkin created"
  	}
  end
end


