# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::ScanForm do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a scanform' do
      shipment = client.shipment.create(Fixture.one_call_buy_shipment)

      scan_form = client.scan_form.create(
        shipments: [shipment],
      )

      expect(scan_form).to be_an_instance_of(EasyPost::Models::ScanForm)
      expect(scan_form.id).to match('sf_')
    end
  end

  describe '.retrieve' do
    it 'retrieves a scanform' do
      shipment = client.shipment.create(Fixture.one_call_buy_shipment)

      scan_form = client.scan_form.create(
        shipments: [shipment],
      )

      retrieved_scan_form = client.scan_form.retrieve(scan_form.id)

      expect(retrieved_scan_form).to be_an_instance_of(EasyPost::Models::ScanForm)
      expect(retrieved_scan_form.to_s).to eq(scan_form.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all scanforms' do
      scan_forms = client.scan_form.all(
        page_size: Fixture.page_size,
      )

      scan_forms_array = scan_forms.scan_forms

      expect(scan_forms_array.count).to be <= Fixture.page_size
      expect(scan_forms.has_more).not_to be_nil
      expect(scan_forms_array).to all(be_an_instance_of(EasyPost::Models::ScanForm))
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
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end
end
