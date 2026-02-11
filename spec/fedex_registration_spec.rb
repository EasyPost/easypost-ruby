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

      response = client.fedex_registration.register_address(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::FedExAccountValidationResponse)
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

      response = client.fedex_registration.request_pin(fedex_account_number, 'SMS')

      expect(response).to be_an_instance_of(EasyPost::Models::FedExRequestPinResponse)
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

      response = client.fedex_registration.validate_pin(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::FedExAccountValidationResponse)
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

      response = client.fedex_registration.submit_invoice(fedex_account_number, params)

      expect(response).to be_an_instance_of(EasyPost::Models::FedExAccountValidationResponse)
      expect(response.id).to eq('ca_123')
      expect(response.object).to eq('CarrierAccount')
      expect(response.type).to eq('FedexAccount')
      expect(response.credentials['account_number']).to eq('123456789')
      expect(response.credentials['mfa_key']).to eq('123456789-XXXXX')
    end
  end
end
