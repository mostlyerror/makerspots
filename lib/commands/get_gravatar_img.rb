require 'digest/md5'

class MakerSpots::GetGravatar

	  # options: filetype, size (dimensions in px), default (url)
		# if opts[:default] is set, default img won't resize, even with opts[:size] set!
	  # more info: https://en.gravatar.com/site/implement/images/
	def self.run(email, opts = {})
		hash = Digest::MD5.hexdigest(email.downcase)
		img_url = "http://www.gravatar.com/avatar/#{hash}.#{opts[:filetype] || 'png'}"
		img_url += "?s=#{opts[:size] || 80}"
		img_url += "&d=#{opts[:default] || 'http://imgur.com/lKf9ONN'}"
		{
			success?: true,
			gravatar: img_url
		}
	end

end
