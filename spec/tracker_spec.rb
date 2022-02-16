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
