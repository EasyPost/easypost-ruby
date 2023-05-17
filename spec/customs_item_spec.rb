# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CustomsItem do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a customs item' do
      customs_item = client.customs_item.create(Fixture.basic_customs_item)

      expect(customs_item).to be_an_instance_of(EasyPost::Models::CustomsItem)
      expect(customs_item.id).to match('cstitem_')
      expect(customs_item.value).to eq('23.25')
    end
  end

  describe '.retrieve' do
    it 'retrieves a customs item' do
      customs_item = client.customs_item.create(Fixture.basic_customs_item)
      retrieved_customs_item = client.customs_item.retrieve(customs_item.id)

      expect(retrieved_customs_item).to be_an_instance_of(EasyPost::Models::CustomsItem)
      expect(retrieved_customs_item.to_s).to eq(customs_item.to_s)
    end
  end
end
