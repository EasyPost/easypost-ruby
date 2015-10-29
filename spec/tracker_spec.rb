require 'spec_helper'

describe EasyPost::Tracker do
  let(:tracking_code)  { 'EZ2000000002' }
  let(:carrier)        { 'usps' }

  describe '#create' do
    it 'tracks' do
      tracker = EasyPost::Tracker.create({
        tracking_code: tracking_code,
        carrier: carrier
      })

      expect(tracker.carrier).to eq(carrier.upcase)
      expect(tracker.tracking_code).to eq(tracking_code)
      expect(tracker.status).to eq("in_transit")
      expect(tracker.tracking_details.length).to be > 0
    end
  end

  describe '#index' do
    it 'retrieves a full page of trackers' do
      trackers = EasyPost::Tracker.all

      expect(trackers["trackers"].count).to eq(30)
      expect(trackers["has_more"]).to eq(true)
    end

    it 'retrieves all trackers with given tracking code, up to a page' do
      trackers = EasyPost::Tracker.all(tracking_code: tracking_code)

      expect(trackers["trackers"].count).to eq(30)
      expect(trackers["has_more"]).to eq(true)
    end

    it 'retrieves all trackers with given tracking code and carrier, up to a page' do
      trackers = EasyPost::Tracker.all(tracking_code: tracking_code, carrier: carrier)

      expect(trackers["trackers"].count).to eq(30)
      expect(trackers["has_more"]).to eq(true)
    end

    it 'retrieves trackers correctly based on datetime' do
      datetime = Time.now.utc

      tracker = EasyPost::Tracker.create({
        tracking_code: tracking_code,
        carrier: carrier
      })

      trackers = EasyPost::Tracker.all(start_datetime: datetime)

      expect(trackers["trackers"].count).to eq(1)
      expect(trackers["trackers"].first.id).to eq(tracker.id)
      expect(trackers["has_more"]).to eq(false)

      trackers = EasyPost::Tracker.all(end_datetime: datetime)

      expect(trackers["trackers"].count).to eq(30)
      trackers["trackers"].each do |trk|
        expect(trk.id).not_to eq(tracker.id)
      end
      expect(trackers["has_more"]).to eq(true)
    end

    it 'retrieves trackers correctly based on id' do
      tracker = EasyPost::Tracker.create({
        tracking_code: tracking_code,
        carrier: carrier
      })

      tracker2 = EasyPost::Tracker.create({
        tracking_code: tracking_code,
        carrier: carrier
      })

      trackers = EasyPost::Tracker.all(after_id: tracker.id)

      expect(trackers["trackers"].count).to eq(1)
      expect(trackers["trackers"].first.id).to eq(tracker2.id)
      expect(trackers["trackers"].first.id).not_to eq(tracker.id)
      expect(trackers["has_more"]).to eq(false)

      trackers = EasyPost::Tracker.all(before_id: tracker.id)

      expect(trackers["trackers"].count).to eq(30)
      trackers["trackers"].each do |trk|
        expect(trk.id).not_to eq(tracker.id)
        expect(trk.id).not_to eq(tracker2.id)
      end
      expect(trackers["has_more"]).to eq(true)
    end
  end
end
