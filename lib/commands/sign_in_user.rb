class MakerSpots::SignInUser

  def self.run(email, password)

  	user = MakerSpots.db.get_user_by_email(email)
  	return { success?: false, error: "Email does not match our records" } if !user
  	return { success?: false, error: "Incorrect Password" } if password != user.password
    result = {
      success?: true,
      user: user,
      message: "#{user.name} signed in."
    }
    gravatar = MakerSpots::GetGravatar.run(email)
    gravatar[:success?] ? result.merge(gravatar) : result
  end
end
