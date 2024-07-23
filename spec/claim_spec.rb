# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Claim do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a claim object' do
      amount = '100'
      insured_shipment = create_and_insure_shipment(client, amount)
      claim_data = Fixture.basic_claim
      claim_data[:tracking_code] = insured_shipment.tracking_code
      claim_data[:amount] = amount
      claim = client.claim.create(claim_data)

      expect(claim).to be_an_instance_of(EasyPost::Models::Claim)
      expect(claim.id).to match('clm_')
    end
  end

  describe '.retrieve' do
    it 'retrieves a claim object' do
      amount = '100'
      insured_shipment = create_and_insure_shipment(client, amount)
      claim_data = Fixture.basic_claim
      claim_data[:tracking_code] = insured_shipment.tracking_code
      claim_data[:amount] = amount
      claim = client.claim.create(claim_data)

      retrieved_claim = client.claim.retrieve(claim.id)

      expect(retrieved_claim).to be_an_instance_of(EasyPost::Models::Claim)
      expect(retrieved_claim.id).to eq(claim.id)
    end
  end

  describe '.all' do
    it 'retrieves all claim objects' do
      all_claims = client.claim.all(
        page_size: Fixture.page_size,
      )
      expect(all_claims[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)

      insurance_array = all_claims.claims

      expect(insurance_array.count).to be <= Fixture.page_size
      expect(all_claims.has_more).not_to be_nil
      expect(insurance_array).to all(be_an_instance_of(EasyPost::Models::Claim))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.claim.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.claim.get_next_page(first_page)

        first_page_first_id = first_page.claims.first.id
        next_page_first_id = next_page.claims.first.id

        expect(first_page_first_id).not_to eq(next_page_first_id)
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY],
        )
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end

  describe '.cancel' do
    it 'cancels an claim' do
      amount = '100'
      insured_shipment = create_and_insure_shipment(client, amount)
      claim_data = Fixture.basic_claim
      claim_data[:tracking_code] = insured_shipment.tracking_code
      claim_data[:amount] = amount
      claim = client.claim.create(claim_data)

      cancelled_claim = client.claim.cancel(claim.id)

      expect(cancelled_claim).to be_an_instance_of(EasyPost::Models::Claim)
      expect(cancelled_claim.id).to match('clm_')
      expect(cancelled_claim.status).to eq('cancelled')
    end
  end
end
