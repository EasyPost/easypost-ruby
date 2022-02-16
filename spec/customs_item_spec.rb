# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::CustomsItem do
  describe '.create' do
    it 'creates a customs item' do
      customs_item = described_class.create(Fixture.basic_customs_item)

      expect(customs_item).to be_an_instance_of(described_class)
      expect(customs_item.id).to match('cstitem_')
      expect(customs_item.value).to eq('23.0')
    end
  end

  describe '.retrieve' do
    it 'retrieves a customs item' do
      customs_item = described_class.create(Fixture.basic_customs_item)
      retrieved_customs_item = described_class.retrieve(customs_item.id)

      expect(retrieved_customs_item).to be_an_instance_of(described_class)
      expect(retrieved_customs_item.to_s).to eq(customs_item.to_s)
    end
  end

  describe '.all' do
    it 'raises not implemented error' do
      expect { described_class.all }.to raise_error(NotImplementedError)
    end
  end
end
