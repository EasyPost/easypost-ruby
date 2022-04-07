# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Insurance do
  describe '.create' do
    it 'creates an insurance object' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      insurance_data = Fixture.basic_insurance
      insurance_data[:tracking_code] = shipment.tracking_code

      insurance = described_class.create(insurance_data)

      expect(insurance).to be_an_instance_of(described_class)
      expect(insurance.id).to match('ins_')
    end
  end

  describe '.retrieve' do
    it 'retrieves an insurance object' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      insurance_data = Fixture.basic_insurance
      insurance_data[:tracking_code] = shipment.tracking_code

      insurance = described_class.create(insurance_data)

      retrieved_insurance = described_class.retrieve(insurance.id)

      expect(retrieved_insurance).to be_an_instance_of(described_class)
      expect(retrieved_insurance.id).to eq(insurance.id)
    end
  end

  describe '.all' do
    it 'retrieves all insurance objects' do
      all_insurance = described_class.all(
        page_size: Fixture.page_size,
      )

      insurance_array = all_insurance.insurances

      expect(insurance_array.count).to be <= Fixture.page_size
      expect(all_insurance.has_more).not_to be_nil
      expect(insurance_array).to all(be_an_instance_of(described_class))
    end
  end
end
