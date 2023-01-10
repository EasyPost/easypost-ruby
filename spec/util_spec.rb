# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Util do
  describe '#normalize_string_list' do
    it 'handles a pre-normalized list' do
      expect(described_class.normalize_string_list(%w[foo bar baz])).to eq %w[foo bar baz]
    end

    it 'handles comma-separated strings' do
      expect(described_class.normalize_string_list('foo,bar,Baz')).to eq %w[foo bar baz]
    end

    it 'handles symbols' do
      expect(described_class.normalize_string_list([:foo, :bar, :baz])).to eq %w[foo bar baz]
    end
  end

  describe '#os_name' do
    it 'returns correct OS name for Linux' do
      stub_const('RUBY_PLATFORM', 'linux')
      expect(described_class.os_name).to eq 'Linux'
    end

    it 'returns correct OS name for Darwin' do
      stub_const('RUBY_PLATFORM', 'darwin')
      expect(described_class.os_name).to eq 'Darwin'
    end

    it 'returns correct OS name for Windows' do
      stub_const('RUBY_PLATFORM', 'wince')
      expect(described_class.os_name).to eq 'Windows'
    end

    it 'returns correct OS name for Unknown' do
      stub_const('RUBY_PLATFORM', 'other-os')
      expect(described_class.os_name).to eq 'Unknown'
    end
  end

  describe '#form_encode_params' do
    it 'form-encodes params' do
      expect(described_class.form_encode_params({ parent_key: { nested_key: '123' } }))
        .to eq({ 'parent_key[nested_key]' => '123' })
    end
  end

  describe '.convert_to_easypost_object' do
    it 'converts a hash to a specific class by matching ID prefix' do
      data = {
        id: 'adr_123',
      }.to_hash
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_a(EasyPost::Address)
    end

    it 'converts a hash to a specific class by matching object type' do
      data = {
        object: 'Address',
      }
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_a(EasyPost::Address)
    end

    it 'converts a hash to a generic EasyPostObject if no matching ID or object type' do
      data = {
        id: 'foo_123',
        object: 'Nothing',
      }
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_a(EasyPost::EasyPostObject)
    end

    it 'converts a hash to a generic EasyPostObject if missing ID and object type' do
      data = {
        random_key: 'random_value',
      }
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_a(EasyPost::EasyPostObject)
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
      object = described_class.convert_to_easypost_object(data, nil)

      # No matching ID prefix or "object" key means the outer object will just be deserialized to an EasyPostObject
      expect(object).to be_a(EasyPost::EasyPostObject)

      # The sub-hashes have proper prefixes, so they will be converted to their respective objects
      expect(object[:primary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
      expect(object[:secondary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
    end

    it 'converts an array of hashes to an array of EasyPostObjects' do
      data = [
        {
          'id' => 'foo_123',
        },
      ]
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_an(Array)
      expect(object.first).to be_a(EasyPost::EasyPostObject)
    end

    it 'converts an array of hashes to an array of specific classes if matching ID prefix or object type' do
      data = [
        {
          'id' => 'adr_123',
        },
      ]
      object = described_class.convert_to_easypost_object(data, nil)

      expect(object).to be_an(Array)
      expect(object.first).to be_a(EasyPost::Address)
    end
  end
end
