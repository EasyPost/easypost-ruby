# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Tracker do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a tracker' do
      tracker = client.tracker.create(
        tracking_code: 'EZ1000000001',
      )

      expect(tracker).to be_an_instance_of(EasyPost::Models::Tracker)
      expect(tracker.id).to match('trk_')
      expect(tracker.status).to eq('pre_transit')
    end
  end

  describe '.retrieve' do
    it 'retrieves a tracker' do
      tracker = client.tracker.create(
        tracking_code: 'EZ1000000001',
      )

      retrieved_tracker = client.tracker.retrieve(tracker.id)

      expect(retrieved_tracker).to be_an_instance_of(EasyPost::Models::Tracker)
      expect(retrieved_tracker.id).to eq(tracker.id)
    end
  end

  describe '.all' do
    it 'retrieves all trackers' do
      trackers = client.tracker.all(
        page_size: Fixture.page_size,
      )
      expect(trackers[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)
      expect(trackers[:_filters]).to include(:tracking_code, :carrier)

      trackers_array = trackers.trackers

      expect(trackers_array.count).to be <= Fixture.page_size
      expect(trackers.has_more).not_to be_nil
      expect(trackers_array).to all(be_an_instance_of(EasyPost::Models::Tracker))
    end

    it 'stores the params used to retrieve the trackers' do
      tracking_code = 'EZ1000000001'
      carrier = 'USPS'

      trackers = client.tracker.all(
        page_size: Fixture.page_size,
        tracking_code: tracking_code,
        carrier: carrier,
      )

      expect(trackers[:_filters][:tracking_code]).to eq(tracking_code)
      expect(trackers[:_filters][:carrier]).to eq(carrier)
    end
  end

  describe '.retrieve_batch' do
    it 'retrieves a batch of trackers' do
      tracker = client.tracker.create(
        tracking_code: 'EZ1000000001',
      )

      trackers = client.tracker.retrieve_batch(
        tracking_codes: [tracker.tracking_code],
      )

      expect(trackers).to be_an_instance_of(EasyPost::Models::Tracker)
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.tracker.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.tracker.get_next_page(first_page)

        first_page_first_id = first_page.trackers.first.id
        next_page_first_id = next_page.trackers.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY],
        )
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end
end
