# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Beta::EndShipper, :authenticate_prod do
  describe '.create' do
    it 'creates an EndShipper object' do
      end_shipper_address = described_class.create(Fixture.end_shipper_address)

      expect(end_shipper_address).to be_an_instance_of(described_class)
      expect(end_shipper_address.id).to match('es_')
      expect(end_shipper_address.street1).to eq('388 TOWNSEND ST APT 20')
    end
  end

  describe '.retrieve' do
    it 'retrieves an EndShipper object' do
      end_shipper_address = described_class.create(Fixture.end_shipper_address)
      retrieved_end_shipper_address = described_class.retrieve(end_shipper_address.id)

      expect(retrieved_end_shipper_address).to be_an_instance_of(described_class)
      expect(retrieved_end_shipper_address.street1).to eq(end_shipper_address.street1)
    end
  end

  describe '.all' do
    it 'retrieves all EndShipper objects' do
      end_shipper_addresses = described_class.all(
        page_size: Fixture.page_size,
      )

      expect(end_shipper_addresses.count).to be <= Fixture.page_size
      expect(end_shipper_addresses).to all(be_an_instance_of(described_class))
    end
  end

  describe '.save' do
    it 'updates the EndShipper object' do
      end_shipper_address = described_class.create(Fixture.end_shipper_address)

      end_shipper_address.name = 'Jack Sparrow'
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
      expect(saved_address.phone).to eq('9999999999')
    end
  end
end
