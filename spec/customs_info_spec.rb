# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CustomsInfo do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a customs info' do
      customs_info = client.customs_info.create(Fixture.basic_customs_info)

      expect(customs_info).to be_an_instance_of(EasyPost::Models::CustomsInfo)
      expect(customs_info.customs_items).to all(be_an_instance_of(EasyPost::Models::CustomsItem))
      expect(customs_info.id).to match('cstinfo_')
      expect(customs_info.eel_pfc).to eq('NOEEI 30.37(a)')
    end
  end

  describe '.retrieve' do
    it 'retrieves a customs info' do
      customs_info = client.customs_info.create(Fixture.basic_customs_info)
      retrieved_customs_info = client.customs_info.retrieve(customs_info.id)

      expect(retrieved_customs_info).to be_an_instance_of(EasyPost::Models::CustomsInfo)
      expect(retrieved_customs_info.to_s).to eq(customs_info.to_s)
    end
  end
end
