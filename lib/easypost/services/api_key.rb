# frozen_string_literal: true

class EasyPost::Services::ApiKey < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::ApiKey # :nodoc:

  # Retrieve a list of all ApiKey objects.
  def all
    response = @client.make_request(:get, 'api_keys')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
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

  # Create an API key for a child or referral customer user
  def create(mode)
    response = @client.make_request(:post, 'api_keys', { mode: mode })

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Delete an API key for a child or referral customer user
  def delete(id)
    @client.make_request(:delete, "api_keys/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Enable an API key for a child or referral customer user
  def enable(id)
    response = @client.make_request(:post, "api_keys/#{id}/enable")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Disable an API key for a child or referral customer user
  def disable(id)
    response = @client.make_request(:post, "api_keys/#{id}/disable")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
