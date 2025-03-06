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
