# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Exceptions do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }
  let(:fake_client) { EasyPost::Client.new(api_key: 'not_a_real_key') }

  describe 'client' do
    it('raises exception when API returns error') {
      expect do
        fake_client.address.create({})
      end.to raise_error(EasyPost::Exceptions::ApiError)
    }
  end
end
