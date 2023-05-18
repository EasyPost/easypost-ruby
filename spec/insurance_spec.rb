# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Insurance do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates an insurance object' do
      shipment = client.shipment.create(Fixture.one_call_buy_shipment)

      insurance_data = Fixture.basic_insurance
      insurance_data[:tracking_code] = shipment.tracking_code

      insurance = client.insurance.create(insurance_data)

      expect(insurance).to be_an_instance_of(EasyPost::Models::Insurance)
      expect(insurance.id).to match('ins_')
    end
  end

  describe '.retrieve' do
    it 'retrieves an insurance object' do
      shipment = client.shipment.create(Fixture.one_call_buy_shipment)

      insurance_data = Fixture.basic_insurance
      insurance_data[:tracking_code] = shipment.tracking_code

      insurance = client.insurance.create(insurance_data)

      retrieved_insurance = client.insurance.retrieve(insurance.id)

      expect(retrieved_insurance).to be_an_instance_of(EasyPost::Models::Insurance)
      expect(retrieved_insurance.id).to eq(insurance.id)
    end
  end

  describe '.all' do
    it 'retrieves all insurance objects' do
      all_insurances = client.insurance.all(
        page_size: Fixture.page_size,
      )

      insurance_array = all_insurances.insurances

      expect(insurance_array.count).to be <= Fixture.page_size
      expect(all_insurances.has_more).not_to be_nil
      expect(insurance_array).to all(be_an_instance_of(EasyPost::Models::Insurance))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.insurance.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.insurance.get_next_page(first_page)

        first_page_first_id = first_page.insurances.first.id
        next_page_first_id = next_page.insurances.first.id

        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Exceptions::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end
end
