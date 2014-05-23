require 'digest/md5'

class MakerSpots::SignInUser

  def self.run(email, password)
  	user = MakerSpots.db.get_user_by_email(email)
  	return { success?: false, error: "Email does not match our records" } if !user
  	return { success?: false, error: "Incorrect Password" } if password != user.password
  	{
  		success?: true,
  		user: user,
  		user_gravatar_img: self.get_gravatar_img(user.email),
  		message: "#{user.name} signed in."
  	}
  end

	def self.get_gravatar_img(email, filetype='png', size=100, default='mm')
		hash = Digest::MD5.hexdigest(email.downcase)
		"http://www.gravatar.com/avatar/#{hash}.#{filetype}?s=#{size}&d=#{default}"
	end
end