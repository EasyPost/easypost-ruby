# frozen_string_literal: true

class EasyPost::Services::ApiKey < EasyPost::Services::Service
  # Retrieve a list of all ApiKey objects.
  def all
    @client.make_request(:get, 'api_keys', EasyPost::Models::ApiKey)
  end

  # Retrieve a list of ApiKey objects (works for the authenticated user or a child user).
  def retrieve_api_keys_for_user(id)
    api_keys = all

    if api_keys.id == id
      # This function was called on the authenticated user
      return api_keys.keys
    end

    # This function was called on a child user (authenticated as parent, only return this child user's details).
    api_keys.children.each do |child|
      if child.id == id
        return child.keys
      end
    end

    raise EasyPost::Errors::FilteringError.new(EasyPost::Constants::NO_USER_FOUND)
  end
end
