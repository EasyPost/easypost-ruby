# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Event do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.retrieve' do
    it 'retrieves an event' do
      events = client.event.all(
        page_size: Fixture.page_size,
      )

      retrieved_event = client.event.retrieve(events.events[0].id)

      expect(retrieved_event).to be_an_instance_of(EasyPost::Models::Event)
      expect(retrieved_event.id).to match('evt_')
    end
  end

  describe '.all' do
    it 'retrieves all events' do
      events = client.event.all(
        page_size: Fixture.page_size,
      )
      expect(events[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)

      events_array = events.events

      expect(events_array.count).to be <= Fixture.page_size
      expect(events.has_more).not_to be_nil
      expect(events_array).to all(be_an_instance_of(EasyPost::Models::Event))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.event.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.event.get_next_page(first_page)

        first_page_first_id = first_page.events.first.id
        next_page_first_id = next_page.events.first.id

        expect(first_page_first_id).not_to eq(next_page_first_id)
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]
        )
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end

  describe '.receive' do
    it 'receives (converts) an event' do
      event = EasyPost::Util.receive_event(Fixture.event_json)

      expect(event).to be_an_instance_of(EasyPost::Models::EasyPostObject)
      expect(event.id).to match('evt_')
    end
  end

  describe '.retrieve_all_payloads' do
    it 'retrieve all payloads' do
      # Create a webhook to receive the event
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
      )

      # Create a batch to trigger an event
      _ = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait for the event to be created
      end

      events = client.event.all(
        page_size: Fixture.page_size,
      )

      event = events.events[0]

      payloads = client.event.retrieve_all_payloads(event.id)

      payload_array = payloads.payloads

      expect(payload_array).to all(be_an_instance_of(EasyPost::Models::Payload))

      client.webhook.delete(webhook.id)
    end
  end

  describe '.retrieve_a_payload' do
    it 'retrieve a payload' do
      # Create a webhook to receive the event
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
      )

      # Create a batch to trigger an event
      _ = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait for the event to be created
      end

      events = client.event.all(
        page_size: Fixture.page_size,
      )

      event = events.events[0]

      begin
        # Payload does not exist due to queueing, so this will throw an exception
        client.event.retrieve_payload(event.id, 'payload_11111111111111111111111111111111')
      rescue EasyPost::Errors::ApiError => e
        expect(e.status_code).to eq(404)
      end

      client.webhook.delete(webhook.id)
    end
  end
end
