# frozen_string_literal: true

require 'spec_helper'
require 'faraday'
require 'typhoeus'
require 'ostruct'

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
          OpenStruct.new(code: 401, body: '{}')
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

    describe 'hooks' do
      after { EasyPost::Hooks.send(:subscribers).clear }

      it 'subscribes to request events' do
        notifications = []
        client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'])
        client.subscribe_request_hook do |request_data|
          expect(request_data).to be_an(EasyPost::Hooks::RequestContext)
          expect(request_data.method).to eq(:get)
          expect(request_data.path).to end_with('/addresses/adr_123')
          expect(request_data.headers['Content-Type']).to eq('application/json')
          # Because the library is making a GET request, it is expected the request to not have a body
          expect(request_data.request_body).to be_nil
          expect(request_data.request_timestamp).to be_a(Time)
          expect(request_data.request_uuid).to be_a(String)
          notifications << request_data
        end
        expect(EasyPost::Hooks.any_subscribers?(:request)).to eq(true)
        expect(EasyPost::Hooks.any_subscribers?(:response)).to eq(false)

        expect {
          client.address.retrieve('adr_123')
        }.to raise_error(EasyPost::Errors::NotFoundError) # Address doesn't exist

        expect(notifications.size).to eq(1)
      end

      it 'subscribes to response events' do
        address_to_create = Fixture.ca_address1
        lifecycle_request_uuid = ''
        request_notifications = []
        response_notifications = []
        client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'])
        client.subscribe_request_hook do |request_data|
          expect(request_data).to be_an(EasyPost::Hooks::RequestContext)
          expect(request_data.method).to eq(:post)
          expect(request_data.path).to end_with('/addresses')
          expect(request_data.headers['Content-Type']).to eq('application/json')
          expect(JSON.parse(request_data.request_body)).to eq(address_to_create)
          expect(request_data.request_timestamp).to be_a(Time)
          expect(request_data.request_uuid).to be_a(String)
          lifecycle_request_uuid = request_data.request_uuid
          request_notifications << request_data
        end
        client.subscribe_response_hook do |response_data|
          expect(response_data).to be_an(EasyPost::Hooks::ResponseContext)
          expect(response_data.http_status).to eq(201)
          expect(response_data.method).to eq(:post)
          expect(response_data.path).to end_with('/addresses')
          expect(response_data.headers['content-type']).to include('application/json')
          expect(response_data.response_body['object']).to eq('Address')
          expect(response_data.request_timestamp).to be_a(Time)
          expect(response_data.response_timestamp).to be_a(Time)
          # Might break due to machine clock
          expect(response_data.response_timestamp > response_data.request_timestamp).to eq(true)
          expect(response_data.request_uuid).to eq(lifecycle_request_uuid)
          response_notifications << response_data
        end
        expect(EasyPost::Hooks.any_subscribers?(:request)).to eq(true)
        expect(EasyPost::Hooks.any_subscribers?(:response)).to eq(true)

        address = client.address.create(address_to_create)
        expect(address).to be_an(EasyPost::Models::Address)
        expect(request_notifications.size).to eq(1)
        expect(response_notifications.size).to eq(1)
      end

      it 'notifies multiple subscribers' do
        request_notifications = []
        response_notifications = []
        request_notifier = ->(data) { request_notifications << data }
        response_notifier = ->(data) { response_notifications << data }
        client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'])

        client.subscribe_request_hook(&request_notifier)
        client.subscribe_request_hook(&request_notifier)
        client.subscribe_request_hook(&request_notifier)
        client.subscribe_response_hook(&response_notifier)
        client.subscribe_response_hook(&response_notifier)

        expect(EasyPost::Hooks.any_subscribers?(:request)).to eq(true)
        expect(EasyPost::Hooks.any_subscribers?(:response)).to eq(true)

        expect {
          client.address.retrieve('adr_123')
        }.to raise_error(EasyPost::Errors::NotFoundError) # Address doesn't exist

        expect(request_notifications.size).to eq(3)
        expect(response_notifications.size).to eq(2)
      end

      it 'removes subscribers' do
        request_notifications = []
        response_notifications = []
        request_notifier = ->(data) { request_notifications << data }
        response_notifier = ->(data) { response_notifications << data }
        client = described_class.new(api_key: ENV['EASYPOST_TEST_API_KEY'])

        request_notifier_name = client.subscribe_request_hook(&request_notifier)
        response_notifier_name = client.subscribe_response_hook(&response_notifier)

        expect(EasyPost::Hooks.any_subscribers?(:request)).to eq(true)
        expect(EasyPost::Hooks.any_subscribers?(:response)).to eq(true)
        expect(client.unsubscribe_request_hook(request_notifier_name)).to eq(request_notifier)
        expect(client.unsubscribe_response_hook(response_notifier_name)).to eq(response_notifier)

        expect {
          client.address.retrieve('adr_123')
        }.to raise_error(EasyPost::Errors::NotFoundError) # Address doesn't exist

        expect(request_notifications).to be_empty
        expect(response_notifications).to be_empty
        expect(EasyPost::Hooks.any_subscribers?(:request)).to eq(false)
        expect(EasyPost::Hooks.any_subscribers?(:response)).to eq(false)
      end
    end
  end
end
