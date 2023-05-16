# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Services::Rate do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.retrieve' do
    it 'retrieves a rate' do
      shipment = EasyPost::Shipment.create(Fixture.basic_shipment)

      rate = client.rate.retrieve(shipment.rates[0].id)

      expect(rate).to be_an_instance_of(EasyPost::Models::Rate)
      expect(rate.id).to match('rate')
    end
  end

  # Below tests are for beta stateless rates
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
        }.to raise_error(EasyPost::Error, 'No rates found.')

        expect {
          EasyPost::Util.get_lowest_stateless_rate(stateless_rates, [], ['invalid_service'])
        }.to raise_error(EasyPost::Error, 'No rates found.')
      end
    end
  end
end
