# frozen_string_literal: true

class EasyPost::Services::User < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::User

  # Create a child User.
  def create(params = {})
    @client.make_request(:post, 'users', MODEL_CLASS, params)
  end

  # Retrieve a user
  def retrieve(id)
    @client.make_request(:get, "users/#{id}", MODEL_CLASS)
  end

  # Retrieve the authenticated User.
  def retrieve_me
    @client.make_request(:get, 'users', MODEL_CLASS)
  end

  # Update a User
  def update(id, params = {})
    @client.make_request(:put, "users/#{id}", MODEL_CLASS, params)
  end

  # Delete a User
  def delete(id)
    @client.make_request(:delete, "users/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve a list of all ApiKey objects.
  def all_api_keys
    @client.make_request(:get, 'api_keys', EasyPost::Models::ApiKey)
  end

  # Retrieve a list of ApiKey objects (works for the authenticated user or a child user).
  def api_keys(id)
    api_keys = all_api_keys

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

  # Update the Brand of a User.
  def update_brand(id, params = {})
    wrapped_params = { brand: params }

    @client.make_request(:get, "users/#{id}/brand", EasyPost::Models::Brand, wrapped_params)
  end
end
