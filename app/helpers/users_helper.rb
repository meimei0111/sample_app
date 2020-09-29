module UsersHelper
	def gravatar_for user, options = {size: Settings.collections.gravatar.size.default}
    size = options[:size]
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
		gravatar_url = "#{Settings.links.gravatar.secure}#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
