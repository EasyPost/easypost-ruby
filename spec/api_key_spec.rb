# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::ApiKey, :authenticate_prod do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.all' do
    it 'retrieves all API keys' do
      api_keys = client.api_key.all

      expect(api_keys.keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
      api_keys.children.each do |child|
        expect(child.keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
      end
    end
  end

  describe '.retrieve_api_keys_for_user' do
    it "retrieves the authenticated user's API keys" do
      user = client.user.retrieve_me
      api_keys = client.api_key.retrieve_api_keys_for_user(user.id)

      expect(api_keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
    end

    it "retrieves child user's API keys as a parent" do
      user = client.user.create(
        name: 'Test User',
      )
      child_user = client.user.retrieve(user.id)

      api_keys = client.api_key.retrieve_api_keys_for_user(child_user.id)

      expect(api_keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))

      client.user.delete(user.id) # delete the user so we don't clutter the test environment
    end
  end
end
