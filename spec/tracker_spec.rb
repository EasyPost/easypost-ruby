# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Tracker do
  describe '.create' do
    it 'creates a tracker' do
      tracker = described_class.create(
        tracking_code: 'EZ1000000001',
      )

      expect(tracker).to be_an_instance_of(described_class)
      expect(tracker.id).to match('trk_')
      expect(tracker.status).to eq('pre_transit')
    end
  end

  describe '.retrieve' do
    it 'retrieves a tracker' do
      tracker = described_class.create(
        tracking_code: 'EZ1000000001',
      )

      retrieved_tracker = described_class.retrieve(tracker.id)

      expect(retrieved_tracker).to be_an_instance_of(described_class)
      expect(retrieved_tracker.id).to eq(tracker.id)
    end
  end

  describe '.all' do
    it 'retrieves all trackers' do
      trackers = described_class.all(
        page_size: Fixture.page_size,
      )

      trackers_array = trackers.trackers

      expect(trackers_array.count).to be <= Fixture.page_size
      expect(trackers.has_more).not_to be_nil
      expect(trackers_array).to all(be_an_instance_of(described_class))
    end

    it 'stores the params used to retrieve the trackers' do
      tracking_code = 'EZ1000000001'
      carrier = 'USPS'

      trackers = described_class.all(
        page_size: Fixture.page_size,
        tracking_code: tracking_code,
        carrier: carrier,
      )

      expect(trackers.tracking_code).to eq(tracking_code)
      expect(trackers.carrier).to eq(carrier)
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.trackers.first.id
        next_page_first_id = next_page.trackers.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end

    it 'reuses the params used to retrieve the first page' do
      tracking_code = 'EZ1000000001'
      carrier = 'USPS'

      first_page = described_class.all(
        page_size: Fixture.page_size,
        tracking_code: tracking_code,
        carrier: carrier,
      )

      # No trackers match the above filters, so we need to mock up some fake results
      trackers = [described_class.new(id: 'trk_1')]

      next_page_params = described_class.build_next_page_params(first_page, trackers, 0)

      expect(next_page_params[:tracking_code]).to eq(tracking_code)
      expect(next_page_params[:carrier]).to eq(carrier)
    end
  end

  describe '.create_list' do
    it 'creates trackers in bulk from a list of tracking codes' do
      # This endpoint/method does not return anything, just make sure the request doesn't fail
      expect {
        described_class.create_list(
          {
            '0' => { tracking_code: 'EZ1000000001' },
            '1' => { tracking_code: 'EZ1000000002' },
            '2' => { tracking_code: 'EZ1000000003' },
            '3' => { tracking_code: 'EZ1000000004' },
          },
        )
      }.not_to raise_error
    end
  end
end
