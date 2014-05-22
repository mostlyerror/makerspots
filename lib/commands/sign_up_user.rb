class MakerSpots::SignUpUser

  def self.run(data)

    # check if user exists
    existing_user = MakerSpots.db.get_user_by_email(data[:email])

    unless existing_user
      user = MakerSpots.db.create_user(data)
    else
      return { success?: false, error: "that user email already exists" }
    end
    {
      success?: true,
      user: user,
      message: "User successfully created."
    }
  end
end


