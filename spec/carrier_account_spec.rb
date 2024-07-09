# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CarrierAccount do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.create' do
    it 'creates a carrier account' do
      carrier_account = client.carrier_account.create(Fixture.basic_carrier_account)

      expect(carrier_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
      expect(carrier_account.id).to match('ca_')
      expect(carrier_account.type).to eq('DhlEcsAccount')

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      client.carrier_account.delete(carrier_account.id)
    end

    it 'creates an UPS account' do
      carrier_account = client.carrier_account.create({type: 'UpsAccount', account_number: '123456789'})

      expect(carrier_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
      expect(carrier_account.id).to match('ca_')
      expect(carrier_account.type).to eq('UpsAccount')

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      client.carrier_account.delete(carrier_account.id)
    end

    it 'sends FedexAccount to the correct endpoint' do
      allow(client).to receive(:make_request).with(
        :post, 'carrier_accounts/register',
        { carrier_account: { type: 'FedexAccount' } },
      ).and_return({ 'id' => 'ca_123' })

      response = client.carrier_account.create(type: 'FedexAccount')

      expect(response['id']).to eq('ca_123')
    end
  end

  describe '.retrieve' do
    it 'retrieves a carrier account' do
      carrier_account = client.carrier_account.create(Fixture.basic_carrier_account)
      retrieved_carrier_account = client.carrier_account.retrieve(carrier_account.id)

      expect(retrieved_carrier_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
      expect(retrieved_carrier_account.to_s).to eq(carrier_account.to_s)

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      client.carrier_account.delete(carrier_account.id)
    end
  end

  describe '.all' do
    it 'retrieves all carrier accounts' do
      carrier_accounts = client.carrier_account.all

      expect(carrier_accounts).to all(be_an_instance_of(EasyPost::Models::CarrierAccount))
    end
  end

  describe '.update' do
    it 'updates a carrier account' do
      test_description = 'My custom description'

      carrier_account = client.carrier_account.create(Fixture.basic_carrier_account)

      updated_carrier_account = client.carrier_account.update(carrier_account.id, description: test_description)

      expect(updated_carrier_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
      expect(updated_carrier_account.id).to match('ca_')
      expect(updated_carrier_account.description).to eq(test_description)

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      client.carrier_account.delete(carrier_account.id)
    end

    it 'updates an ups account' do
      ups_account = client.carrier_account.create({type: 'UpsAccount', account_number: '123456789'})

      updated_ups_account = client.carrier_account.update(ups_account.id, account_number: '987654321')

      expect(updated_ups_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
      expect(updated_ups_account.id).to match('ca_')
      expect(updated_ups_account.type).to eq('UpsAccount')

      # Remove the carrier account once we have tested it so we don't pollute the account with test accounts
      client.carrier_account.delete(ups_account.id)
    end
  end

  describe '.delete' do
    it 'deletes a carrier account' do
      carrier_account = client.carrier_account.create(Fixture.basic_carrier_account)

      expect {
        client.carrier_account.delete(carrier_account.id)
      }.not_to raise_error
    end
  end
end
