# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::User, :authenticate_prod do
  describe '.create' do
    xit 'creates a child user' do
      # This endpoint returns the child user keys in plain text, do not run this test.
      user = described_class.create(
        name: 'Test User',
      )

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
      expect(user.name).to eq('Test User')
    end
  end

  describe '.retrieve' do
    it 'retrieves a child user' do
      authenticated_user = described_class.retrieve_me
      user = described_class.retrieve(authenticated_user.children[0].id)

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

      test_phone = '5555555555'

      user.phone_number = test_phone
      user.save

      expect(user).to be_an_instance_of(described_class)
      expect(user.id).to match('user_')
      expect(user.phone_number).to eq(test_phone)
    end
  end

  describe '.delete' do
    xit 'deletes a user' do
      # Due to our inability to create child users securely, we must also skip deleting them as we cannot replace the deleted ones easily.
      user.delete
    end
  end

  describe '.all_api_keys' do
    xit 'retrieves all API keys' do
      # API keys are returned as plaintext, do not run this test.
      user.all_api_keys
    end
  end

  describe '.api_keys' do
    xit "retrieves the authenticated user's API keys" do
      # API keys are returned as plaintext, do not run this test.
      user.api_keys
    end
  end

  describe '.update_brand' do
    it "updates the authenticated user's brand" do
      # API keys are returned as plaintext, do not run this test.
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
