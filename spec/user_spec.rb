# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::User, :authenticate_prod do
  describe '.create' do
    it 'creates a child user' do
      user = described_class.create(
        name: 'Test User',
      )

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
      expect(user.name).to eq('Test User')

      user.delete # delete the user so we don't clutter the test environment
    end
  end

  describe '.retrieve' do
    it 'retrieves a user' do
      authenticated_user = described_class.retrieve_me
      user = described_class.retrieve(authenticated_user.id)

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
    end
  end

  describe '.retrieve_me' do
    it 'retrieves the authenticated user' do
      user = described_class.retrieve_me

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
    end
  end

  describe '.update' do
    it 'updates a user' do
      user = described_class.retrieve_me

      test_name = 'New Test Name'

      user.name = test_name
      user.save

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
      expect(user.name).to eq(test_name)
    end
  end

  describe '.delete' do
    it 'deletes a user' do
      user = described_class.create(
        name: 'Test User',
      )

      # Nothing gets returned here, simply ensure no error gets raised
      user.delete
    end
  end

  describe '.all_api_keys' do
    it 'retrieves all API keys' do
      api_keys = described_class.all_api_keys

      expect(api_keys.keys).to all(be_an_instance_of(EasyPost::ApiKey))
      api_keys.children.each do |child|
        expect(child.keys).to all(be_an_instance_of(EasyPost::ApiKey))
      end
    end
  end

  describe '.api_keys' do
    it "retrieves the authenticated user's API keys" do
      user = described_class.retrieve_me
      api_keys = user.api_keys

      expect(api_keys).to all(be_an_instance_of(EasyPost::ApiKey))
    end

    it "retrieves child user's API keys as a parent" do
      user = described_class.create(
        name: 'Test User',
      )
      child_user = described_class.retrieve(user.id)

      api_keys = child_user.api_keys

      expect(api_keys).to all(be_an_instance_of(EasyPost::ApiKey))

      user.delete # delete the user so we don't clutter the test environment
    end
  end

  describe '.update_brand' do
    it "updates the authenticated user's brand" do
      user = described_class.retrieve_me

      color = '#123456'

      brand = user.update_brand(
        color: color,
      )

      expect(brand).to be_an_instance_of(EasyPost::Brand)
      expect(brand.id).to match('brd_')
      expect(brand.color).to eq(color)
    end
  end
end
