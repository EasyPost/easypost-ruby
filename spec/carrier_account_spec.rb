# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::CarrierAccount do
  before do
    EasyPost.api_key = ENV['EASYPOST_PROD_API_KEY']
  end

  describe '.create' do
    it 'creates a carrier account' do
      carrier_account = described_class.create(Fixture.basic_carrier_account)

      expect(carrier_account).to be_an_instance_of(described_class)
      expect(carrier_account.id).to match('ca_')
      expect(carrier_account.type).to eq('UpsAccount')

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      carrier_account.delete
    end
  end

  describe '.retrieve' do
    it 'retrieves a carrier account' do
      carrier_account = described_class.create(Fixture.basic_carrier_account)
      retrieved_carrier_account = described_class.retrieve(carrier_account.id)

      expect(retrieved_carrier_account).to be_an_instance_of(described_class)
      expect(retrieved_carrier_account.to_s).to eq(carrier_account.to_s)

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      carrier_account.delete
    end
  end

  describe '.all' do
    it 'retrieves all carrier accounts' do
      carrier_accounts = described_class.all

      expect(carrier_accounts).to all(be_an_instance_of(described_class))
    end
  end

  describe '.save' do
    it 'updates a carrier account' do
      test_description = 'My custom description'

      carrier_account = described_class.create(Fixture.basic_carrier_account)

      carrier_account.description = test_description
      carrier_account.save

      expect(carrier_account).to be_an_instance_of(described_class)
      expect(carrier_account.id).to match('ca_')
      expect(carrier_account.description).to eq(test_description)

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      carrier_account.delete
    end
  end

  describe '.delete' do
    xit 'deletes a carrier account' do
      # No need to re-test this here since we delete each carrier account after each test right now
      carrier_account = described_class.create(Fixture.basic_carrier_account)

      response = carrier_account.delete

      expect(response).to eq({})
    end
  end

  describe '.types' do
    it 'retrieves the carrier account types available' do
      types = described_class.types()

      expect(types).to be_an_instance_of(Array)
    end
  end
end
