require 'spec_helper'

describe EasyPost::Address do
  describe ".create_and_verify" do
    context "for a successful response without an address" do
      it "should raise an error" do
        expect(EasyPost).to receive(:request).and_return([{}, ""])
        expect {
          EasyPost::Address.create_and_verify(ADDRESS[:california])
        }.to raise_error EasyPost::Error, /Unable to verify addres/
      end
    end
  end

  describe '#create' do
    it 'creates an address object' do
      address = EasyPost::Address.create(ADDRESS[:california])

      expect(address).to be_an_instance_of(EasyPost::Address)
      expect(address.company).to eq('EasyPost')
    end
  end

  describe '#verify' do
    it 'verifies an address with an error' do
      address = EasyPost::Address.create(
        ADDRESS[:california].reject {|k,v| k == :street1 || k == :company}
      )

      expect(address.street1).to be_nil
      expect(address.street2).to eq('Unit 1')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      expect {
        address.verify()
      }.to raise_error EasyPost::Error, /Unable to verify addres/
    end

    it 'verifies an address without message' do
      address = EasyPost::Address.create(ADDRESS[:california])

      expect(address.street2).to be

      verified_address = address.verify()
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message]).to be_nil
    end

    it 'verifies an address using a carrier' do
      address = EasyPost::Address.create(ADDRESS[:california])

      expect(address.company).to eq('EasyPost')
      expect(address.street1).to eq('164 Townsend Street')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      verified_address = address.verify(carrier: :usps)
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
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

      expect {
        address.verify()
      }.to raise_error(EasyPost::Error, /Unable to verify addres/)
    end
  end
end
