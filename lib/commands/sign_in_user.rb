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

  # more info: https://en.gravatar.com/site/implement/images/
  # if opts[:default] is set, the image will not be resized, even with opts[:size!]
	def self.get_gravatar_img(email, opts={})
		hash = Digest::MD5.hexdigest(email.downcase)
		url = "http://www.gravatar.com/avatar/#{hash}.#{opts[:filetype] || 'png'}"
		url += "?s=#{opts[:size] || 80}"
		url += "&d=#{opts[:default] || 'mm'}"
	end
end