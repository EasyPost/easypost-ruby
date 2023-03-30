# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Event do
  describe '.retrieve' do
    it 'retrieves an event' do
      events = described_class.all(
        page_size: Fixture.page_size,
      )

      retrieved_event = described_class.retrieve(events.events[0].id)

      expect(retrieved_event).to be_an_instance_of(described_class)
      expect(retrieved_event.id).to match('evt_')
    end
  end

  describe '.all' do
    it 'retrieves all events' do
      events = described_class.all(
        page_size: Fixture.page_size,
      )

      events_array = events.events

      expect(events_array.count).to be <= Fixture.page_size
      expect(events.has_more).not_to be_nil
      expect(events_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.events.first.id
        next_page_first_id = next_page.events.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end
  end

  describe '.receive' do
    it 'receives (converts) an event' do
      event = described_class.receive(Fixture.event_json)

      expect(event).to be_an_instance_of(described_class)
      expect(event.id).to match('evt_')
    end
  end

  describe '.retrieve_all_payloads' do
    it 'retrieve all payloads' do
      # Create a webhook to receive the event
      webhook = EasyPost::Webhook.create(
        url: Fixture.webhook_url,
      )

      # Create a batch to trigger an event
      _ = EasyPost::Batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait for the event to be created
      end

      events = described_class.all(
        page_size: Fixture.page_size,
      )

      event = events.events[0]

      payloads = event.retrieve_all_payloads

      payload_array = payloads.payloads

      expect(payload_array).to all(be_an_instance_of(EasyPost::Payload))

      webhook.delete
    end
  end

  describe '.retrieve_a_payload' do
    it 'retrieve a payload' do
      # Create a webhook to receive the event
      webhook = EasyPost::Webhook.create(
        url: Fixture.webhook_url,
      )

      # Create a batch to trigger an event
      _ = EasyPost::Batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait for the event to be created
      end

      events = described_class.all(
        page_size: Fixture.page_size,
      )

      event = events.events[0]

      begin
        # Payload does not exist due to queueing, so this will throw an exception
        event.retrieve_payload('payload_11111111111111111111111111111111')
      rescue EasyPost::Error => e
        expect(e.status).to eq(404)
      end

      webhook.delete
    end
  end
end
