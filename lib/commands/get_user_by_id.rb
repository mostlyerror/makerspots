class MakerSpots::GetUserById

  def self.run(user_id)
    user = MakerSpots.db.get_user_by_id(user_id)
    return { success?: false, error: "Could not get user by id" } if user.nil?
    {
      success?: true,
      user: user
    }
  end
end
