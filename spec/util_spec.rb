# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Util do
  describe '#normalize_string_list' do
    it 'handles a pre-normalized list' do
      expect(EasyPost::InternalUtilities.normalize_string_list(%w[foo bar baz])).to eq %w[foo bar baz]
    end

    it 'handles comma-separated strings' do
      expect(EasyPost::InternalUtilities.normalize_string_list('foo,bar,Baz')).to eq %w[foo bar baz]
    end

    it 'handles symbols' do
      expect(EasyPost::InternalUtilities.normalize_string_list([:foo, :bar, :baz])).to eq %w[foo bar baz]
    end
  end

  describe '#os_name' do
    it 'returns correct OS name for Linux' do
      stub_const('RUBY_PLATFORM', 'linux')
      expect(EasyPost::InternalUtilities::System.os_name).to eq 'Linux'
    end

    it 'returns correct OS name for Darwin' do
      stub_const('RUBY_PLATFORM', 'darwin')
      expect(EasyPost::InternalUtilities::System.os_name).to eq 'Darwin'
    end

    it 'returns correct OS name for Windows' do
      stub_const('RUBY_PLATFORM', 'wince')
      expect(EasyPost::InternalUtilities::System.os_name).to eq 'Windows'
    end

    it 'returns correct OS name for Unknown' do
      stub_const('RUBY_PLATFORM', 'other-os')
      expect(EasyPost::InternalUtilities::System.os_name).to eq 'Unknown'
    end
  end

  describe '#form_encode_params' do
    it 'form-encodes params' do
      expect(EasyPost::InternalUtilities.form_encode_params({ parent_key: { nested_key: '123' } }))
        .to eq({ 'parent_key[nested_key]' => '123' })
    end
  end

  describe '.convert_json_to_object' do
    it 'converts a hash to a specific class' do
      data = {
        id: 'adr_123',
      }.to_hash
      object = EasyPost::InternalUtilities::Json.convert_json_to_object(data, EasyPost::Models::Address)

      expect(object).to be_a(EasyPost::Models::Address)
    end

    it 'converts a hash to a generic EasyPostObject' do
      data = {
        id: 'foo_123',
        object: 'Nothing',
      }
      object = EasyPost::InternalUtilities::Json.convert_json_to_object(data)

      expect(object).to be_a(EasyPost::Models::EasyPostObject)
    end

    it 'converts sub-hashes to EasyPost object' do
      data = {
        'id' => '123',
        'primary_payment_method' => {
          'id' => 'bank_123',
        },
        'secondary_payment_method' => {
          'id' => 'card_123',
        },
      }
      object = EasyPost::InternalUtilities::Json.convert_json_to_object(data)

      # No matching ID prefix or "object" key means the outer object will just be deserialized to an EasyPostObject
      expect(object).to be_a(EasyPost::Models::EasyPostObject)

      # The sub-hashes have proper prefixes, so they will be converted to their respective objects
      expect(object.primary_payment_method).to be_an_instance_of(EasyPost::Models::PaymentMethod)
      expect(object.secondary_payment_method).to be_an_instance_of(EasyPost::Models::PaymentMethod)
    end

    it 'converts an array of hashes to an array of EasyPostObjects' do
      data = [
        {
          'id' => 'foo_123',
        },
      ]
      object = EasyPost::InternalUtilities::Json.convert_json_to_object(data)

      expect(object).to be_an(Array)
      expect(object.first).to be_a(EasyPost::Models::EasyPostObject)
    end

    it 'converts an array of hashes to an array of specific classes if matching ID prefix or object type' do
      data = [
        {
          'id' => 'adr_123',
        },
      ]
      object = EasyPost::InternalUtilities::Json.convert_json_to_object(data, EasyPost::Models::Address)

      expect(object).to be_an(Array)
      expect(object.first).to be_a(EasyPost::Models::Address)
    end
  end

  describe 'Setter and getter' do
    it 'test updating/retrieving an EasyPostObject attribute' do
      data = { 'id' => 'adr_123' }
      address = EasyPost::InternalUtilities::Json.convert_json_to_object(data, EasyPost::Models::Address)

      address.id = 'fake_id'

      expect(address.id).to eq('fake_id')
    end
  end
end
