# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Exceptions do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }
  let(:fake_client) { EasyPost::Client.new(api_key: 'not_a_real_key') }

  describe 'api error' do
    it 'raised when API returns error' do
      expect {
        fake_client.address.create({})
      }.to raise_error(EasyPost::Exceptions::ApiError)
    end

    it 'deserialize HTTP error response properly' do
      # bad request
      address = client.address.create(street1: 'invalid')
      client.address.verify(address.id)
    rescue EasyPost::Exceptions::InvalidRequestError => e
      # should construct an InvalidRequestError object correctly
      expect(e.message).to eq('Unable to verify address.')
      expect(e.code).to eq('ADDRESS.VERIFY.FAILURE')
      expect(e.errors).to be_a(Array)
      expect(e.errors).not_to be_empty
      first_error = e.errors.first
      expect(first_error).to be_a(EasyPost::Models::Error)
      expect(first_error.field).not_to be_nil
      expect(first_error.code).not_to be_nil
      expect(first_error.message).not_to be_nil
    end

    it 'pretty prints properly' do
      # bad request
      address = client.address.create(street1: 'invalid')
      client.address.verify(address.id)
    rescue EasyPost::Exceptions::InvalidRequestError => e
      expect(e.pretty_print).to be_a(String)
      expect(e.pretty_print).not_to be_empty
      expect(e.pretty_print).to include('Unable to verify address.')
    end
  end
end
