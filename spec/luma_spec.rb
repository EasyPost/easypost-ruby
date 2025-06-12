# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Luma do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.get_promise' do
    it 'gets service recommendations from Luma based on your ruleset' do
      basic_shipment = Fixture.basic_shipment
      basic_shipment['ruleset_name'] = Fixture.luma_ruleset_name
      basic_shipment['planned_ship_date'] = Fixture.luma_planned_ship_date

      response = client.luma.get_promise(basic_shipment)

      expect(response.luma_info.luma_selected_rate).not_to be_nil
    end
  end
end
