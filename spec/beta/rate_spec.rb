# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Beta::Rate do
  describe '.list' do
    it 'retrieve all stateless rates' do
      stateless_rates = described_class.retrieve_stateless_rate(Fixture.basic_shipment)

      expect(stateless_rates).to all(be_an_instance_of(EasyPost::Rate))
    end

    describe '.lowest rate' do
      it 'retrieve lowest stateless rate' do
        stateless_rates = described_class.retrieve_stateless_rate(Fixture.basic_shipment)

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
