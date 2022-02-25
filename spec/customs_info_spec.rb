# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::CustomsInfo do
  describe '.create' do
    it 'creates a customs info' do
      customs_info = described_class.create(Fixture.basic_customs_info)

      expect(customs_info).to be_an_instance_of(described_class)
      expect(customs_info.id).to match('cstinfo_')
      expect(customs_info.eel_pfc).to eq('NOEEI 30.37(a)')
    end
  end

  describe '.retrieve' do
    it 'retrieves a customs info' do
      customs_info = described_class.create(Fixture.basic_customs_info)
      retrieved_customs_info = described_class.retrieve(customs_info.id)

      expect(retrieved_customs_info).to be_an_instance_of(described_class)
      expect(retrieved_customs_info.to_s).to eq(customs_info.to_s)
    end
  end

  describe '.all' do
    it 'raises not implemented error' do
      expect { described_class.all }.to raise_error(NotImplementedError)
    end
  end
end
