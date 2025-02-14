# frozen_string_literal: true

class EasyPost::Services::User < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::User # :nodoc:

  # Create a child User.
  def create(params = {})
    response = @client.make_request(:post, 'users', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a user
  def retrieve(id)
    response = @client.make_request(:get, "users/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve the authenticated User.
  def retrieve_me
    response = @client.make_request(:get, 'users')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Update a User
  def update(id, params = {})
    response = @client.make_request(:put, "users/#{id}", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Delete a User
  def delete(id)
    @client.make_request(:delete, "users/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve a list of all ApiKey objects.
  def all_api_keys
    warn '[DEPRECATION] `all_api_keys` is deprecated. Please use `all` in the `api_key` service instead.'
    response = @client.make_request(:get, 'api_keys')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::ApiKey)
  end

  # Retrieve a list of ApiKey objects (works for the authenticated user or a child user).
  def api_keys(id)
    warn '[DEPRECATION] `api_keys` is deprecated.
Please use `retrieve_api_keys_for_user` in the `api_key` service instead.'

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
    response = @client.make_request(:patch, "users/#{id}/brand", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Brand)
  end

  # Retrieve all child Users.
  def all_children(params = {})
    filters = { key: 'children' }

    get_all_helper('users/children', EasyPost::Models::User, params, filters)
  end

  # Get the next page of child users.
  def get_next_page_of_children(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { after_id: collection.children.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all_children(params)
  end
end
