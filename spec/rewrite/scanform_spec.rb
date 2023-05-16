# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::ScanForm do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a scanform' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      scanform = client.scan_form.create(
        shipments: [shipment],
      )

      expect(scanform).to be_an_instance_of(EasyPost::Models::ScanForm)
      expect(scanform.id).to match('sf_')
    end
  end

  describe '.retrieve' do
    it 'retrieves a scanform' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      scanform = client.scan_form.create(
        shipments: [shipment],
      )

      retrieved_scanform = client.scan_form.retrieve(scanform.id)

      expect(retrieved_scanform).to be_an_instance_of(EasyPost::Models::ScanForm)
      expect(retrieved_scanform.to_s).to eq(scanform.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all scanforms' do
      scanforms = client.scan_form.all(
        page_size: Fixture.page_size,
      )

      scanforms_array = scanforms.scan_forms

      expect(scanforms_array.count).to be <= Fixture.page_size
      expect(scanforms.has_more).not_to be_nil
      expect(scanforms_array).to all(be_an_instance_of(EasyPost::Models::ScanForm))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.scan_form.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.scan_form.get_next_page(first_page)

        first_page_first_id = first_page.scan_forms.first.id
        next_page_first_id = next_page.scan_forms.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end
  end
end
