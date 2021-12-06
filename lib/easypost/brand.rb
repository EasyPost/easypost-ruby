class EasyPost::Brand < EasyPost::Resource
  def url
    if user_id.nil? || user_id.empty?
      raise EasyPost::Error, "Missing user_id: #{self.class} instance is missing user_id"
    end

    "#{::EasyPost::User.url}/#{CGI.escape(user_id)}/brand"
  end
end
