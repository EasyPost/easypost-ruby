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

      referral_users_array = referral_users.referral_customers

      expect(referral_users_array.count).to be <= Fixture.page_size
      expect(referral_users.has_more).not_to be_nil
      expect(referral_users_array).to all(be_an_instance_of(EasyPost::User))
    end
  end

  describe '.add_credit_card', :vcr do
    it 'adds a credit card to a referral user account' do
      # This test requires a partner user's production API key via EASYPOST_PROD_API_KEY
      # as well as one of that user's referral's production API keys via REFERRAL_USER_PROD_API_KEY.
      #
      # VCR has trouble matching the body of the form-encoded data here, override the default VCR
      # rubocop:disable Metrics/LineLength
      VCR.use_cassette(
        'beta/referral/EasyPost_Beta_Referral_add_credit_card_adds_a_credit_card_to_a_referral_user_account', match_requests_on: [
          :uri, :method,
        ],
      ) do
        # rubocop:enable Metrics/LineLength
        credit_card = described_class.add_credit_card(
          REFERRAL_USER_PROD_API_KEY,
          Fixture.credit_card_details[:number],
          Fixture.credit_card_details[:expiration_month],
          Fixture.credit_card_details[:expiration_year],
          Fixture.credit_card_details[:cvc],
        )

        expect(credit_card.id).to match('card_')
        expect(credit_card.last4).to match('6170')
      end
    end
  end
end
