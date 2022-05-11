# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Beta::Referral, :authenticate_prod do
  describe '.create' do
    xit 'creates a referral user' do
      # Do not record this test in cassette because there is sensitive info
      params = {
        name: 'test test',
        email: 'email@example.com',
        phone: '8888888888',
      }
      created_referral_user = described_class.create(params)

      expect(created_referral_user).to be_an_instance_of(EasyPost::User)
      expect(created_referral_user.id).to match('user_')
      expect(created_referral_user.phone_number).to eq('8888888888')
    end
  end

  describe '.update_email' do
    it 'updates a referral user' do
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
    it 'retrieve all referral users' do
      referral_users = described_class.all(
        page_size: Fixture.page_size,
      )

      expect(referral_users.count).to be <= Fixture.page_size
      expect(referral_users).to all(be_an_instance_of(EasyPost::User))
    end
  end

  describe '.add_credit_card' do
    xit 'adds a credit card to a referral user account' do
      # Do not record this test in cassette because there is sensitive info
      credit_card = described_class.add_credit_card(
        'your_referral_user_api_key',
        '1234567890123',
        '00',
        '0000',
        '000',
      )

      expect(credit_card.id).to match('card_')
      expect(credit_card.last4).to match('0123')
    end
  end
end
