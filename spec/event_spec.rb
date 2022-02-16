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

  describe '.receive' do
    it 'receives (converts) an event' do
      event = described_class.receive(Fixture.event)

      expect(event).to be_an_instance_of(described_class)
      expect(event.id).to match('evt_')
    end
  end
end
