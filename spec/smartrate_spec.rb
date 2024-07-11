# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Smartrate do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.deliver_by' do
    it 'retrieve the estimated delivery date' do
      params = {
        from_zip: Fixture.ca_address1['zip'],
        to_zip: Fixture.ca_address2['zip'],
        planned_ship_date: Fixture.planned_ship_date,
        carriers: [Fixture.usps],
      }

      rates = client.smartrate.estimate_delivery_date(params)

      expect(rates['results'].all? { |rate| rate['easypost_time_in_transit_data'] }).not_to be_nil
    end
  end

  describe '.deliver_on' do
    it 'retrieve a recommended ship date' do
      params = {
        from_zip: Fixture.ca_address1['zip'],
        to_zip: Fixture.ca_address2['zip'],
        desired_delivery_date: Fixture.desired_delivery_date,
        carriers: [Fixture.usps],
      }

      rates = client.smartrate.recommend_ship_date(params)

      expect(rates['results'].all? { |rate| rate['easypost_time_in_transit_data'] }).not_to be_nil
    end
  end
end
