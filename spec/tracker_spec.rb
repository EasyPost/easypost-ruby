require 'spec_helper'

describe EasyPost::Tracker do
  describe '#create' do
    it 'tracks' do
      tracking_code = 'EZ2000000002'
      carrier = 'ups'

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
end
