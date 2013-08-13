require 'easypost'
EasyPost.api_key = 'cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi'

describe EasyPost::Address do
  describe '#create' do
    it 'creates an address object' do
      address = EasyPost::Address.create(
        :name => 'Sawyer Bateman',
        :street1 => '1A Larkspur Cres.',
        :city => 'St. Albert',
        :state => 'AB',
        :zip => 't8n2m4',
        :country => 'CA'
      )
      expect(address).to be_an_instance_of(EasyPost::Address)
      expect(address.name).to eq('Sawyer Bateman')
    end
  end
  describe '#verify' do
    it 'verifies an address with message' do
      address = EasyPost::Address.create(
        :company => 'Simpler Postage Inc',
        :street1 => '388 Townsend Street',
        :city => 'San Francisco',
        :state => 'CA',
        :zip => '94107'
      )
      expect(address.company).to eq('Simpler Postage Inc')
      expect(address.street1).to eq('388 Townsend Street')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      verified_address = address.verify()
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message].length).to be > 0 
    end

    it 'verifies an address without message' do
      address = EasyPost::Address.create(
        :company => 'Simpler Postage Inc',
        :street1 => '388 Townsend Street',
        :street2 => 'Apt 20',
        :city => 'San Francisco',
        :state => 'CA',
        :zip => '94107'
      )
      expect(address.company).to eq('Simpler Postage Inc')
      expect(address.street1).to eq('388 Townsend Street')
      expect(address.street2).to eq('Apt 20')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      verified_address = address.verify()
      expect(verified_address).to be_an_instance_of(EasyPost::Address)
      expect(verified_address[:message]).to raise_error(NoMethodError) 
    end

    it 'is not able to verify address' do
      address = EasyPost::Address.create(
        :company => 'Simpler Postage Inc',
        :street1 => '388 Junk Teerts',
        :street2 => 'Apt 20',
        :city => 'San Francisco',
        :state => 'CA',
        :zip => '941abc07'
      )

      expect { verified_address = address.verify() }.to raise_error(EasyPost::Error, /Address Not Found./)
    end
  end

  it "can be serialized with Marshal" do
    address = EasyPost::Address.create(
      :name => 'Sawyer Bateman',
      :street1 => '1A Larkspur Cres.',
      :city => 'St. Albert',
      :state => 'AB',
      :zip => 't8n2m4',
      :country => 'CA'
    )
    expect { Marshal.dump(address) }.to_not raise_error(TypeError)
    serialized_address = Marshal.load(Marshal.dump(address))
    expect(serialized_address).to be_an_instance_of(EasyPost::Address)
    expect(serialized_address.zip).to eq('t8n2m4')
  end
end