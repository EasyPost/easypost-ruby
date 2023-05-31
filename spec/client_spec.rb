# frozen_string_literal: true

require 'spec_helper'
require 'faraday'
require 'typhoeus'

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
        api_key: 'fake_api_key',
        custom_client_exec: lambda { |method, uri, headers, open_timeout, read_timeout, body = nil|
          expect(method).to eq(:get)
          expect(uri).to be_a(URI)
          expect(headers).to be_a(Hash)
          expect(open_timeout).to eq(30)
          expect(read_timeout).to eq(60)
          expect(body).to be_nil
          return OpenStruct.new(code: 401, body: '{}')
        },
      )

      expect {
        client.address.retrieve('adr_123')
      }.to raise_error(EasyPost::Errors::UnauthorizedError) # should throw error because our lambda returns 401
    end

    it 'allows Faraday to be used as a custom client' do
      func = lambda { |method, uri, headers, _open_timeout, _read_timeout, body = nil|
        conn = Faraday.new(url: uri.to_s, headers: headers) do |faraday|
          faraday.adapter Faraday.default_adapter
        end
        conn.public_send(method, uri.path) { |request|
          request.body = body if body
        }.yield_self do |response|
          # Verify that the request went through as expected
          expect(response.env.method).to eq(method)
          expect(response.env.url.to_s).to eq(uri.to_s)
          # Normal users would use response.status and response.body, but for testing we'll explicitly return a 404
          OpenStruct.new(code: 404, body: '{}')
        end
      }
      client = described_class.new(
        api_key: 'fake_api_key',
        custom_client_exec: func,
      )

      expect {
        client.address.retrieve('adr_123')
      }.to raise_error(EasyPost::Errors::NotFoundError) # should throw error because our lambda returns 404
    end

    it 'allows Typhoeus to be used as a custom client' do
      func = lambda { |method, uri, headers, _open_timeout, _read_timeout, body = nil|
        Typhoeus.public_send(
          method,
          uri.to_s,
          headers: headers,
          body: body,
        ).yield_self do |response|
          # Verify that the request went through as expected
          headers.each do |key, value|
            expect(response.request.options[:headers][key]).to eq(value)
          end
          expect(response.request.options[:method]).to eq(method)
          expect(response.request.options[:body]).to eq(body)
          expect(response.request.base_url).to eq(uri.to_s)
          # Normal users would use response.code and response.body, but for testing we'll explicitly return a 404
          OpenStruct.new(code: 404, body: '{}')
        end
      }
      client = described_class.new(
        api_key: 'fake_api_key',
        custom_client_exec: func,
      )

      expect {
        client.address.retrieve('adr_123')
      }.to raise_error(EasyPost::Errors::NotFoundError) # should throw error because our lambda returns 404
    end
  end
end
