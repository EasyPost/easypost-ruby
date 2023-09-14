# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CarrierType do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.all' do
    it 'retrieves all carrier types' do
      carrier_types = client.carrier_type.all

      expect(carrier_types).to all(be_an_instance_of(EasyPost::Models::CarrierType))
    end
  end
end
