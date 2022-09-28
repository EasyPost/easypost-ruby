# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Resource do
  let(:mock_resource) { described_class.new(class_name: 'resource') }

  describe 'class name' do
    it 'is not implemented' do
      expect {
        mock_resource.url
      }.to raise_error(NotImplementedError)
        .with_message(
          'Resource is an abstract class. You should perform actions on its subclasses (Address, Shipment, etc.)',
        )
    end
  end

  describe '.each' do
    it 'retrieves all addresses when enumerating items' do
      # TODO: use `.tally` instead of `.group_by(&:itself).transform_values(&:count)` once Ruby <=2.6 dropped
      addresses = EasyPost::Address.lazy.take(5).map(&:country).group_by(&:itself).transform_values(&:count)

      expect(addresses).to eq({ 'US' => 5 })
    end
  end
end
