module ProfilesHelper
  def avatar_image_tag(user)
    image_tag("https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.strip.downcase)},",size: "250")
  end
end
