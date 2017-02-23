module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for( user )
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  def is_current?( user )
    current_user.present? && user == current_user
  end
end
