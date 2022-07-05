# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Error do
  describe 'error' do
    it 'handles error parsing' do
      EasyPost::Shipment.create
    rescue described_class => e
      # Test pulling out error properties
      expect(e.status).to eq(422)
      expect(e.code).to eq('SHIPMENT.INVALID_PARAMS')
      expect(e.message).to eq('Unable to create shipment, one or more parameters were invalid.')
      expect(e.errors[0]).to eq({ 'to_address' => 'Required and missing.' })
      expect(e.errors[1]).to eq({ 'from_address' => 'Required and missing.' })
      expect(e.http_body).to eq(
        '{"error":{"code":"SHIPMENT.INVALID_PARAMS","message":"Unable to create shipment,' \
        ' one or more parameters were invalid.","errors":[{"to_address":"Required and missing."},' \
        '{"from_address":"Required and missing."}]}}',
      )

      # Convert an error to a string
      expect(e.to_s).to eq(
        'SHIPMENT.INVALID_PARAMS (422): Unable to create shipment, one or more parameters were invalid.' \
        ' [{"to_address"=>"Required and missing."}, {"from_address"=>"Required and missing."}]',
      )

      # Compare an error and its properties to another error
      # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
      expect(e == e).to be true
      # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
    end
  end
end
