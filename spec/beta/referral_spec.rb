# frozen_string_literal: true

require 'spec_helper'

REFERRAL_USER_PROD_API_KEY = ENV['REFERRAL_USER_PROD_API_KEY'] || '123'

describe EasyPost::Beta::Referral, :authenticate_prod do
  describe '.create' do
    it 'creates a referral user' do
      # This test requires a partner user's production API key via EASYPOST_PROD_API_KEY.
      created_referral_user = described_class.create(
        name: 'test user',
        email: 'email@example.com',
        phone: '8888888888',
      )

      expect(created_referral_user).to be_an_instance_of(EasyPost::User)
      expect(created_referral_user.id).to match('user_')
      expect(created_referral_user.name).to eq('test user')
    end
  end

  describe '.update_email' do
    it 'updates a referral user' do
      # This test requires a partner user's production API key via EASYPOST_PROD_API_KEY.
      referral_users = described_class.all(
        page_size: Fixture.page_size,
      )

      updated_user = described_class.update_email(
        'email2@example.com',
        referral_users[0].id,
      )

      expect(updated_user).to eq(true)
    end
  end

  describe '.all' do
    # This test requires a partner user's production API key via EASYPOST_PROD_API_KEY.
    it 'retrieve all referral users' do
      referral_users = described_class.all(
        page_size: Fixture.page_size,
      )

      expect(referral_users.count).to be <= Fixture.page_size
      expect(referral_users).to all(be_an_instance_of(EasyPost::User))
    end
  end

  describe '.add_credit_card' do
    it 'adds a credit card to a referral user account' do
      # The credit card details below are for a valid proxy card usable
      # for tests only and cannot be used for real transactions.
      #
      # DO NOT alter these details with real credit card information.
      #
      # This test requires a partner user's production API key via EASYPOST_PROD_API_KEY
      # as well as one of that user's referral's production API keys via REFERRAL_USER_PROD_API_KEY.
      credit_card = described_class.add_credit_card(
        REFERRAL_USER_PROD_API_KEY,
        '4536410136126170',
        '05',
        '2028',
        '778',
      )

      expect(credit_card.id).to match('card_')
      expect(credit_card.last4).to match('6170')
    end
  end
end
