# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::EndShipper, :authenticate_prod do
  describe '.create' do
    it 'creates an EndShipper object' do
      end_shipper_address = described_class.create(Fixture.ca_address1)

      expect(end_shipper_address).to be_an_instance_of(described_class)
      expect(end_shipper_address.id).to match('es_')
      expect(end_shipper_address.street1).to eq('388 TOWNSEND ST APT 20')
    end
  end

  describe '.retrieve' do
    it 'retrieves an EndShipper object' do
      end_shipper_address = described_class.create(Fixture.ca_address1)
      retrieved_end_shipper_address = described_class.retrieve(end_shipper_address.id)

      expect(retrieved_end_shipper_address).to be_an_instance_of(described_class)
      expect(retrieved_end_shipper_address.street1).to eq(end_shipper_address.street1)
    end
  end

  describe '.all' do
    it 'retrieves all EndShipper objects' do
      end_shippers = described_class.all(page_size: Fixture.page_size)

      end_shippers_array = end_shippers.end_shippers

      expect(end_shippers_array.count).to be <= Fixture.page_size
      expect(end_shippers.has_more).not_to be_nil
      expect(end_shippers_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.save' do
    it 'updates the EndShipper object' do
      end_shipper_address = described_class.create(Fixture.ca_address1)

      end_shipper_address.name = 'Captain Sparrow'
      end_shipper_address.company = 'EasyPost'
      end_shipper_address.street1 = '388 Townsend St'
      end_shipper_address.street2 = 'Apt 20'
      end_shipper_address.city = 'San Francisco'
      end_shipper_address.state = 'CA'
      end_shipper_address.zip = '94107'
      end_shipper_address.country = 'US'
      end_shipper_address.phone = '9999999999'
      end_shipper_address.email = 'test@example.com'
      saved_address = end_shipper_address.save

      expect(saved_address).to be_an_instance_of(described_class)
      expect(saved_address.id).to match('es_')
      expect(saved_address.name).to eq('CAPTAIN SPARROW') # Address verification will capitalize the name
    end
  end
end
