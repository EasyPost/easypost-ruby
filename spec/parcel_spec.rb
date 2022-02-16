# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Parcel do
  describe '.create' do
    it 'creates a parcel' do
      parcel = described_class.create(Fixture.basic_parcel)

      expect(parcel).to be_an_instance_of(described_class)
      expect(parcel.id).to match('prcl_')
      expect(parcel.weight).to eq(15.4)
    end
  end

  describe '.retrieve' do
    it 'retrieves a parcel' do
      parcel = described_class.create(Fixture.basic_parcel)
      retrieved_parcel = described_class.retrieve(parcel.id)

      expect(retrieved_parcel).to be_an_instance_of(described_class)
      expect(retrieved_parcel.to_s).to eq(parcel.to_s)
    end
  end

  describe '.all' do
    it 'raises not implemented error' do
      expect { described_class.all }.to raise_error(NotImplementedError)
    end
  end
end
