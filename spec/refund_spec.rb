# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Refund do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a refund' do
      shipment = client.shipment.create(Fixture.one_call_buy_shipment)
      retrieved_shipment = client.shipment.retrieve(shipment.id) # We need to retrieve the shipment so that the tracking_code has time to populate

      refund = client.refund.create(
        carrier: Fixture.usps,
        tracking_codes: [retrieved_shipment.tracking_code],
      )

      expect(refund[0].id).to match('rfnd')
      expect(refund[0].status).to eq('submitted')
    end
  end

  describe '.all' do
    it 'retrieves all refunds' do
      refunds = client.refund.all(
        page_size: Fixture.page_size,
      )

      refunds_array = refunds.refunds

      expect(refunds_array.count).to be <= Fixture.page_size
      expect(refunds.has_more).not_to be_nil
      expect(refunds_array).to all(be_an_instance_of(EasyPost::Models::Refund))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.refund.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.refund.get_next_page(first_page)

        first_page_first_id = first_page.refunds.first.id
        next_page_first_id = next_page.refunds.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end

  describe '.retrieve' do
    it 'retrieves a refund' do
      refunds = client.refund.all(
        page_size: Fixture.page_size,
      )

      refunds_array = refunds.refunds

      retrieved_refund = client.refund.retrieve(refunds_array[0].id)

      expect(retrieved_refund).to be_an_instance_of(EasyPost::Models::Refund)
      expect(retrieved_refund.id).to eq(refunds_array[0].id)
    end
  end
end
