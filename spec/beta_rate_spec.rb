# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::BetaRate do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.retrieve_stateless_rates' do
    it 'retrieve all stateless rates' do
      stateless_rates = client.beta_rate.retrieve_stateless_rates(Fixture.basic_shipment)

      expect(stateless_rates).to all(be_an_instance_of(EasyPost::Models::Rate))
    end

    describe '.get_lowest_stateless_rate' do
      it 'gets the lowest stateless rate for various combinations of filters' do
        stateless_rates = client.beta_rate.retrieve_stateless_rates(Fixture.basic_shipment)

        lowest_stateless_rate = EasyPost::Util.get_lowest_stateless_rate(stateless_rates)

        expect(lowest_stateless_rate.service).to match('First')

        expect {
          EasyPost::Util.get_lowest_stateless_rate(stateless_rates, ['invalid_carrier'])
        }.to raise_error(EasyPost::Exceptions::FilteringError, EasyPost::Constants::NO_MATCHING_RATES)

        expect {
          EasyPost::Util.get_lowest_stateless_rate(stateless_rates, [], ['invalid_service'])
        }.to raise_error(EasyPost::Exceptions::FilteringError, EasyPost::Constants::NO_MATCHING_RATES)
      end
    end
  end
end
