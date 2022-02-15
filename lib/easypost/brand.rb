# frozen_string_literal: true

# The Brand object allows you to customize the publicly-accessible html page that shows tracking details for every EasyPost tracker.
class EasyPost::Brand < EasyPost::Resource
  # The url of the Brand object.
  def url
    if user_id.nil? || user_id.empty?
      raise EasyPost::Error, "Missing user_id: #{self.class} instance is missing user_id"
    end

    "#{::EasyPost::User.url}/#{CGI.escape(user_id)}/brand"
  end
end
