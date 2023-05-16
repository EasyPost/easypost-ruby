# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Services::EndShipper do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates an EndShipper object' do
      end_shipper_address = client.end_shipper.create(Fixture.ca_address1)

      expect(end_shipper_address).to be_an_instance_of(EasyPost::Models::EndShipper)
      expect(end_shipper_address.id).to match('es_')
      expect(end_shipper_address.street1).to eq('388 TOWNSEND ST APT 20')
    end
  end

  describe '.retrieve' do
    it 'retrieves an EndShipper object' do
      end_shipper_address = client.end_shipper.create(Fixture.ca_address1)
      retrieved_end_shipper_address = client.end_shipper.retrieve(end_shipper_address.id)

      expect(retrieved_end_shipper_address).to be_an_instance_of(EasyPost::Models::EndShipper)
      expect(retrieved_end_shipper_address.street1).to eq(end_shipper_address.street1)
    end
  end

  describe '.all' do
    it 'retrieves all EndShipper objects' do
      end_shippers = client.end_shipper.all(page_size: Fixture.page_size)

      end_shippers_array = end_shippers.end_shippers

      expect(end_shippers_array.count).to be <= Fixture.page_size
      expect(end_shippers.has_more).not_to be_nil
      expect(end_shippers_array).to all(be_an_instance_of(EasyPost::Models::EndShipper))
    end
  end

  describe '.update' do
    it 'updates the EndShipper object' do
      end_shipper = client.end_shipper.create(Fixture.ca_address1)

      params = Fixture.ca_address1
      params['name'] = 'Captain Sparrow'

      updated_end_shipper = client.end_shipper.update(end_shipper.id, params)

      expect(updated_end_shipper).to be_an_instance_of(EasyPost::Models::EndShipper)
      expect(updated_end_shipper.id).to match('es_')
      expect(updated_end_shipper.name).to eq('CAPTAIN SPARROW') # Address verification will capitalize the name
    end
  end
end
