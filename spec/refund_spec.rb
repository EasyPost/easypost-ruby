# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Refund do
  describe '.create' do
    it 'creates a refund' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)
      retrieved_shipment = EasyPost::Shipment.retrieve(shipment.id) # We need to retrieve the shipment so that the tracking_code has time to populate

      refund = described_class.create(
        carrier: Fixture.usps,
        tracking_codes: [retrieved_shipment.tracking_code],
      )

      expect(refund[0].id).to match('rfnd')
      expect(refund[0].status).to eq('submitted')
    end
  end

  describe '.all' do
    it 'retrieves all refunds' do
      refunds = described_class.all(
        page_size: Fixture.page_size,
      )

      refunds_array = refunds.refunds

      expect(refunds_array.count).to be <= Fixture.page_size
      expect(refunds.has_more).not_to be_nil
      expect(refunds_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.refunds.first.id
        next_page_first_id = next_page.refunds.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end
  end

  describe '.retrieve' do
    it 'retrieves a refund' do
      refunds = described_class.all(
        page_size: Fixture.page_size,
      )

      refunds_array = refunds.refunds

      retrieved_refund = described_class.retrieve(refunds_array[0].id)

      expect(retrieved_refund).to be_an_instance_of(described_class)
      expect(retrieved_refund.id).to eq(refunds_array[0].id)
    end
  end
end
