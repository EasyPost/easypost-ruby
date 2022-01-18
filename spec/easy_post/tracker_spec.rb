# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Tracker do
  let(:tracking_code) { 'EZ2000000002' }
  let(:carrier) { 'USPS' }

  describe '#create' do
    it 'tracks' do
      tracker = described_class.create(
        tracking_code: tracking_code,
        carrier: carrier,
      )

      expect(tracker.carrier).to eq carrier.upcase
      expect(tracker.tracking_code).to eq tracking_code
      expect(tracker.status).to eq 'in_transit'
      expect(tracker.tracking_details.length).to be > 0
    end
  end

  describe '#index' do
    it 'retrieves a full page of trackers' do
      trackers = described_class.all

      expect(trackers['trackers'].count).to eq 30
      expect(trackers['has_more']).to eq true
    end

    it 'retrieves all trackers with given tracking code, up to a page' do
      trackers = described_class.all(tracking_code: tracking_code)

      expect(trackers['trackers'].count).to eq 30
      expect(trackers['has_more']).to eq true
    end

    it 'retrieves all trackers with given tracking code and carrier, up to a page' do
      trackers = described_class.all(tracking_code: tracking_code, carrier: carrier)

      expect(trackers['trackers'].count).to eq 30
      expect(trackers['has_more']).to eq true
    end

    it 'retrieves trackers correctly based on datetime' do
      tracker = described_class.create(
        tracking_code: tracking_code,
        carrier: carrier,
      )

      trackers = described_class.all(
        start_datetime: tracker.created_at,
        tracking_code: tracking_code,
      )

      expect(trackers['trackers'].count).to eq 1
      expect(trackers['trackers'].first.id).to eq tracker.id
      expect(trackers['has_more']).to eq false

      trackers = described_class.all(
        end_datetime: tracker.created_at,
        tracking_code: tracking_code,
      )

      expect(trackers['trackers'].count).to eq 30
      trackers['trackers'].each do |trk|
        expect(trk.id).not_to eq tracker.id
      end
      expect(trackers['has_more']).to eq true
    end

    it 'retrieves trackers correctly based on id' do
      tracker = described_class.create(
        tracking_code: tracking_code,
        carrier: carrier,
      )

      tracker2 = described_class.create(
        tracking_code: tracking_code,
        carrier: carrier,
      )

      trackers = described_class.all(after_id: tracker.id, tracking_code: tracking_code)

      expect(trackers['trackers'].count).to eq 1
      expect(trackers['trackers'].first.id).to eq tracker2.id
      expect(trackers['trackers'].first.id).not_to eq tracker.id
      expect(trackers['has_more']).to eq false

      trackers = described_class.all(before_id: tracker.id, tracking_code: tracking_code)

      expect(trackers['trackers'].count).to eq 30
      trackers['trackers'].each do |trk|
        expect(trk.id).not_to eq tracker.id
        expect(trk.id).not_to eq tracker2.id
      end
      expect(trackers['has_more']).to eq true
    end
  end

  describe '#create_list' do
    it 'creates trackers in bulk from a list of tracking codes' do
      # This endpoint/method does not return anything, just make sure the request doesn't fail
      expect {
        described_class.create_list(
          {
            trackers: {
              '0' => { tracking_code: 'EZ1000000001' },
              '1' => { tracking_code: 'EZ1000000002' },
              '2' => { tracking_code: 'EZ1000000003' },
              '3' => { tracking_code: 'EZ1000000004' },
            },
          },
        )
      }.not_to raise_error
    end
  end
end
