# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Error do
  describe 'error' do
    it 'handles error parsing' do
      EasyPost::Shipment.create
    rescue described_class => e
      aggregate_failures 'test pulling out error properties' do
        expect(e.status).to eq(422)
        expect(e.code).to eq('PARAMETER.REQUIRED')
        expect(e.message).to eq('Missing required parameter.')
        expect(e.errors[0]).to eq({ 'field' => 'shipment', 'message' => 'cannot be blank' })
        # rubocop:disable Layout/LineLength
        expect(e.http_body).to eq(
          '{"error":{"code":"PARAMETER.REQUIRED","message":"Missing required parameter.","errors":[{"field":"shipment","message":"cannot be blank"}]}}',
        )
        # rubocop:enable Layout/LineLength
      end

      # Convert an error to a string
      expect(e.to_s).to eq(
        'PARAMETER.REQUIRED (422): Missing required parameter. [{"field"=>"shipment", "message"=>"cannot be blank"}]',
      )

      # Compare an error and its properties to another error
      expect(e).to eq(e.clone)
    end
  end
end
