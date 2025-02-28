# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Errors do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe 'api error' do
    it 'assigns properties of an error correctly' do
      client.shipment.create({})
    rescue EasyPost::Errors::ApiError => e
      expect(e.status_code).to eq(422)
      expect(e.code).to eq('PARAMETER.REQUIRED')
      expect(e.message).to eq('Missing required parameter.')
      expect(e.errors.first).to eq({ 'field' => 'shipment', 'message' => 'cannot be blank' })
    end

    it 'assigns properties of an error correctly when returned via the alternative format' do
      claim_data = { tracking_code: '123' } # Intentionally pass a bad tracking code

      begin
        client.claim.create(claim_data)
      rescue EasyPost::Errors::ApiError => e
        expect(e.status_code).to eq(404)
        expect(e.code).to eq('NOT_FOUND')
        expect(e.message).to eq('The requested resource could not be found.')
        expect(e.errors.first).to eq('No eligible insurance found with provided tracking code.')
      end
    end

    it 'concatenates error messages that are a list' do
      error = EasyPost::Errors::ApiError.new(message: %w[Error1 Error2])

      expect(error.message).to eq('Error1, Error2')
    end

    it 'concatenates error messages that are a dict' do
      message_data = { 'errors' => ['Bad format 1', 'Bad format 2'] }
      error = EasyPost::Errors::ApiError.new(message: message_data)

      expect(error.message).to eq('Bad format 1, Bad format 2')
    end

    it 'concatenates error messages that have an invalid format' do
      message_data = {
        'errors' => ['Bad format 1', 'Bad format 2'],
        'bad_data' => [
          {
            'first_message' => 'Bad format 3',
            'second_message' => 'Bad format 4',
            'third_message' => 'Bad format 5',
          },
        ],
      }
      error = EasyPost::Errors::ApiError.new(message: message_data)

      expect(error.message).to eq('Bad format 1, Bad format 2, Bad format 3, Bad format 4, Bad format 5')
    end
  end
end
