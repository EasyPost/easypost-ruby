# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Client do
  describe 'client object' do
    it 'create a client object with api key and timeouts' do
      client = described_class.new('fake_api_key', 10, 1)

      expect(client.instance_variable_get('@configuration').instance_variable_get('@read_timeout')).to eq(10)
    end
  end
end
