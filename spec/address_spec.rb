require 'spec_helper'

describe EasyPost::Address do
  describe '#create' do
    it 'creates an address object' do
      address = EasyPost::Address.create(ADDRESS[:california])

      expect(address).to be_an_instance_of(EasyPost::Address)
      expect(address.company).to eq('EasyPost')
    end
  end

  describe '#verify' do
    it 'verifies an address with message' do
      address = EasyPost::Address.create(ADDRESS[:california].reject {|k,v| k == :street2})

      expect(address.company).to eq('EasyPost')
      expect(address.street1).to eq('164 Townsend Street')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')
      expect(address.street2).to be_nil

      verified_address = address.verify()
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message].length).to be > 0
    end

    it 'verifies an address without message' do
      address = EasyPost::Address.create(ADDRESS[:california])

      expect(address.street2).to be

      verified_address = address.verify()
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message]).to be_nil
    end

    it 'verifies an address using fedex' do
      address = EasyPost::Address.create(ADDRESS[:california].reject {|k,v| k == :street2})

      expect(address.company).to eq('EasyPost')
      expect(address.street1).to eq('164 Townsend Street')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')
      expect(address.street2).to be_nil

      verified_address = address.verify(carrier: :fedex)
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message].length).to be > 0
    end

    it 'is not able to verify address' do
      address = EasyPost::Address.create(
        company: 'Simpler Postage Inc',
        street1: '388 Junk Teerts',
        street2: 'Apt 20',
        city: 'San Francisco',
        state: 'CA',
        zip: '941abc07'
      )

      expect { verified_address = address.verify() }.to raise_error(EasyPost::Error, /Address Not Found./)
    end
  end
end
