class MakerSpots::SignInUser

  def self.run(email, password)
  	user = MakerSpots.db.get_user_by_email(email)
  	return { success?: false, error: "Email does not match our records" } if !user
  	return { success?: false, error: "Incorrect Password" } if password != user.password
  	{
  		success?: true,
  		user: user,
  		message: "#{user.name} signed in."
  	}
  end
end
