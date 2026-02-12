# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::FedexRegistration do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.register_address' do
    it 'registers a billing address' do
      fedex_account_number = '123456789'
      address_validation = {
        name: 'BILLING NAME',
        street1: '1234 BILLING STREET',
        city: 'BILLINGCITY',
        state: 'ST',
        postal_code: '12345',
        country_code: 'US',
      }
      easypost_details = {
        carrier_account_id: 'ca_123',
      }
      params = {
        address_validation: address_validation,
        easypost_details: easypost_details,
      }

      json_response = {
        'email_address' => nil,
        'options' => %w[SMS CALL INVOICE],
        'phone_number' => '***-***-9721',
      }

      allow(client).to receive(:make_request).with(
        :post,
        "fedex_registrations/#{fedex_account_number}/address",
        params,
      ).and_return(json_response)

      response = client.fedex_registration.register_address(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::EasyPostObject)
      expect(response.email_address).to be_nil
      expect(response.options).to include('SMS')
      expect(response.options).to include('CALL')
      expect(response.options).to include('INVOICE')
      expect(response.phone_number).to eq('***-***-9721')
    end
  end

  describe '.request_pin' do
    it 'requests a pin' do
      fedex_account_number = '123456789'
      wrapped_params = {
        pin_method: {
          option: 'SMS',
        },
      }

      json_response = {
        'message' => 'sent secured Pin',
      }

      allow(client).to receive(:make_request).with(
        :post,
        "fedex_registrations/#{fedex_account_number}/pin",
        wrapped_params,
      ).and_return(json_response)

      response = client.fedex_registration.request_pin(fedex_account_number, 'SMS')

      expect(response).to be_an_instance_of(EasyPost::Models::EasyPostObject)
      expect(response.message).to eq('sent secured Pin')
    end
  end

  describe '.validate_pin' do
    it 'validates a pin' do
      fedex_account_number = '123456789'
      pin_validation = {
        pin_code: '123456',
        name: 'BILLING NAME',
      }
      easypost_details = {
        carrier_account_id: 'ca_123',
      }
      params = {
        pin_validation: pin_validation,
        easypost_details: easypost_details,
      }

      json_response = {
        'id' => 'ca_123',
        'object' => 'CarrierAccount',
        'type' => 'FedexAccount',
        'credentials' => {
          'account_number' => '123456789',
          'mfa_key' => '123456789-XXXXX',
        },
      }

      allow(client).to receive(:make_request).with(
        :post,
        "fedex_registrations/#{fedex_account_number}/pin/validate",
        params,
      ).and_return(json_response)

      response = client.fedex_registration.validate_pin(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::EasyPostObject)
      expect(response.id).to eq('ca_123')
      expect(response.object).to eq('CarrierAccount')
      expect(response.type).to eq('FedexAccount')
      expect(response.credentials['account_number']).to eq('123456789')
      expect(response.credentials['mfa_key']).to eq('123456789-XXXXX')
    end
  end

  describe '.submit_invoice' do
    it 'submits details about an invoice' do
      fedex_account_number = '123456789'
      invoice_validation = {
        name: 'BILLING NAME',
        invoice_number: 'INV-12345',
        invoice_date: '2025-12-08',
        invoice_amount: '100.00',
        invoice_currency: 'USD',
      }
      easypost_details = {
        carrier_account_id: 'ca_123',
      }
      params = {
        invoice_validation: invoice_validation,
        easypost_details: easypost_details,
      }

      json_response = {
        'id' => 'ca_123',
        'object' => 'CarrierAccount',
        'type' => 'FedexAccount',
        'credentials' => {
          'account_number' => '123456789',
          'mfa_key' => '123456789-XXXXX',
        },
      }

      allow(client).to receive(:make_request).with(
        :post,
        "fedex_registrations/#{fedex_account_number}/invoice",
        params,
      ).and_return(json_response)

      response = client.fedex_registration.submit_invoice(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::EasyPostObject)
      expect(response.id).to eq('ca_123')
      expect(response.object).to eq('CarrierAccount')
      expect(response.type).to eq('FedexAccount')
      expect(response.credentials['account_number']).to eq('123456789')
      expect(response.credentials['mfa_key']).to eq('123456789-XXXXX')
    end
  end
end
