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
      my_api_keys = api_keys.keys
    else
      # This function was called on a child user (authenticated as parent, only return this child user's details).
      my_api_keys = []
      api_keys.children.each do |child|
        if child.id == id
          my_api_keys = child.keys
          break
        end
      end
    end

    my_api_keys
  end
end
