# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Client do
  describe 'client object' do
    it 'create a client object timeouts' do
      client = described_class.new(api_key: 'fake_api_key', read_timeout: 10, open_timeout: 1)

      expect(client.instance_variable_get('@configuration').instance_variable_get('@read_timeout')).to eq(10)
      expect(client.instance_variable_get('@configuration').instance_variable_get('@open_timeout')).to eq(1)
    end

    it 'create a client with api key and api base' do
      client = described_class.new(api_key: 'fake_api_key', api_base: 'https://api.easypostExample.com')
      expect(client.instance_variable_get('@configuration').instance_variable_get('@api_base')).to eq('https://api.easypostExample.com')
    end

    it 'create a client with invalid api key' do
      expect {
        described_class.new(api_key: nil)
      }.to raise_error(EasyPost::Error, 'API key is required.')
    end
  end
end
