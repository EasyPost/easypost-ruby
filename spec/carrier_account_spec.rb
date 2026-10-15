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

    EasyPost::Services::CarrierAccount::CARRIER_ACCOUNT_CREATE_ENDPOINT_TYPES.each do |expected_endpoint, carrier_account_types|
      carrier_account_types.each do |carrier_account_type|
        it "routes #{carrier_account_type} account creation" do
          params = { type: carrier_account_type }
          params[:registration_data] = {} if %w[carrier_accounts/open carrier_accounts/register].include?(expected_endpoint)
          captured_request = {}

          allow(client).to receive(:make_request).and_wrap_original do |original, *args|
            method, endpoint, request_params = args
            if captured_request[:endpoint].nil? && endpoint.start_with?('carrier_accounts')
              captured_request[:method] = method
              captured_request[:endpoint] = endpoint
              captured_request[:params] = request_params
            end
            original.call(*args)
          end

          begin
            carrier_account = client.carrier_account.create(params)
          rescue EasyPost::Errors::ApiError => error
            expect([404, 500]).not_to include(error.status_code)
          else
            expect(carrier_account).to be_an_instance_of(EasyPost::Models::CarrierAccount)
            expect(carrier_account.id).to match('ca_')
            client.carrier_account.delete(carrier_account.id)
          end

          expect(captured_request[:method]).to eq(:post)
          expect(captured_request[:endpoint]).to eq(expected_endpoint)
          if expected_endpoint == 'carrier_accounts/register_oauth'
            expect(captured_request[:params]).to have_key(:carrier_account_oauth_registrations)
          else
            expect(captured_request[:params]).to have_key(:carrier_account)
          end
        end
      end
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
