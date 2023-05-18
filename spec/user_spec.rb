# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::User, :authenticate_prod do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.create' do
    it 'creates a child user' do
      user = client.user.create(
        name: 'Test User',
      )

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
      expect(user.name).to eq('Test User')

      client.user.delete(user.id) # delete the user so we don't clutter the test environment
    end
  end

  describe '.retrieve' do
    it 'retrieves a user' do
      authenticated_user = client.user.retrieve_me
      user = client.user.retrieve(authenticated_user.id)

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
    end
  end

  describe '.retrieve_me' do
    it 'retrieves the authenticated user' do
      user = client.user.retrieve_me

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
    end
  end

  describe '.update' do
    it 'updates a user' do
      user = client.user.retrieve_me

      test_name = 'New Test Name'

      updated_user = client.user.update(user.id, test_name)

      expect(updated_user).to be_an_instance_of(EasyPost::Models::User)
      expect(updated_user.id).to match('user_')
      expect(updated_user.name).to eq(test_name)
    end
  end

  describe '.delete' do
    it 'deletes a user' do
      user = client.user.create(
        name: 'Test User',
      )

      # Nothing gets returned here, simply ensure no error gets raised
      client.user.delete(user.id)
    end
  end

  describe '.all_api_keys' do
    it 'retrieves all API keys' do
      api_keys = client.user.all_api_keys

      expect(api_keys.keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
      api_keys.children.each do |child|
        expect(child.keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
      end
    end
  end

  describe '.api_keys' do
    it "retrieves the authenticated user's API keys" do
      user = client.user.retrieve_me
      api_keys = client.user.api_keys(user.id)

      expect(api_keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))
    end

    it "retrieves child user's API keys as a parent" do
      user = client.user.create(
        name: 'Test User',
      )
      child_user = client.user.retrieve(user.id)

      api_keys = client.user.api_keys(child_user.id)

      expect(api_keys).to all(be_an_instance_of(EasyPost::Models::ApiKey))

      client.user.delete(user.id) # delete the user so we don't clutter the test environment
    end
  end

  describe '.update_brand' do
    it "updates the authenticated user's brand" do
      user = client.user.retrieve_me

      color = '#123456'

      brand = client.user.update_brand(
        user.id,
        color: color,
      )

      expect(brand).to be_an_instance_of(EasyPost::Models::Brand)
      expect(brand.id).to match('brd_')
      expect(brand.color).to eq(color)
    end
  end
end
