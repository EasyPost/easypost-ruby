# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Client do
  describe 'client object' do
    it 'create a client object timeouts' do
      client = described_class.new(api_key: 'fake_api_key', read_timeout: 10, open_timeout: 1)

      expect(client.read_timeout).to eq(10)
      expect(client.open_timeout).to eq(1)
    end

    it 'create a client with api key and api base' do
      client = described_class.new(api_key: 'fake_api_key', api_base: 'https://api.easypostExample.com')
      expect(client.api_base).to eq('https://api.easypostExample.com')
    end

    it 'create a client with a missing api key' do
      expect {
        described_class.new(api_key: nil)
      }.to raise_error(
        EasyPost::Errors::MissingParameterError,
        EasyPost::Constants::MISSING_REQUIRED_PARAMETER % 'api_key',
      )
    end

    it 'create a client with read timeout' do
      client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'], read_timeout: 0.001, open_timeout: 10)

      expect {
        client.address.create(Fixture.ca_address1)
      }.to raise_error(EasyPost::Errors::TimeoutError)
    end

    it 'create a client with open timeout' do
      client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'], read_timeout: 10, open_timeout: 0.001)

      expect {
        client.address.create(Fixture.ca_address1)
      }.to raise_error(EasyPost::Errors::TimeoutError)
    end

    it 'calls custom client exec' do
      client = described_class.new(
        api_key: ENV['EASYPOST_TEST_API_KEY'],
        custom_client_exec: lambda { |method, uri, headers, open_timeout, read_timeout, body = nil|
          expect(method).to eq('get')
          expect(uri).to be_a(URI)
          expect(headers).to be_a(Hash)
          expect(open_timeout).to eq(10)
          expect(read_timeout).to eq(10)
          expect(body).to be_nil
        },
      )

      client.address.retrieve('adr_123')
    end
  end
end
