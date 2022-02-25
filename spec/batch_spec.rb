# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Batch do
  describe '.create' do
    it 'creates a batch' do
      batch = described_class.create(
        shipments: [Fixture.basic_address],
      )

      expect(batch).to be_an_instance_of(described_class)
      expect(batch.id).to match('batch_')
      expect(batch.shipments).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves a batch' do
      batch = described_class.create(Fixture.basic_address)
      retrieved_batch = described_class.retrieve(batch.id)

      expect(retrieved_batch).to be_an_instance_of(described_class)
      expect(retrieved_batch.id).to eq(batch.id)
    end
  end

  describe '.all' do
    it 'retrieves all batches' do
      batches = described_class.all(
        page_size: Fixture.page_size,
      )

      batch_array = batches.batches

      expect(batch_array.count).to be <= Fixture.page_size
      expect(batches.has_more).not_to be_nil
      expect(batch_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.create_and_buy' do
    it 'creates and buys a batch in a single call' do
      batch = described_class.create_and_buy(
        shipments: [
          Fixture.one_call_buy_shipment,
          Fixture.one_call_buy_shipment,
        ],
      )

      expect(batch).to be_an_instance_of(described_class)
      expect(batch.id).to match('batch_')
      expect(batch.num_shipments).to eq(2)
    end
  end

  describe '.buy' do
    it 'buys a batch' do
      batch = described_class.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      batch.buy

      expect(batch).to be_an_instance_of(described_class)
      expect(batch.num_shipments).to eq(1)
    end
  end

  describe '.create_scan_form' do
    it 'creates a scanform for a batch' do
      batch = described_class.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      batch.buy

      # Uncomment the following line if you need to re-record the cassette
      # sleep(1) # Wait enough time for the batch to process buying the shipment

      batch.create_scan_form

      # We can't assert anything meaningful here because the scanform gets queued for generation and may not be immediately available
      expect(batch).to be_an_instance_of(described_class)
    end
  end

  describe 'add/remove shipments' do
    it 'adds and removes shipments from a batch' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      batch = described_class.create

      batch.add_shipments(
        shipments: [shipment],
      )
      expect(batch.num_shipments).to eq(1)

      batch.remove_shipments(
        shipments: [shipment],
      )
      expect(batch.num_shipments).to eq(0)
    end
  end

  describe '.label' do
    it 'generates a label for a batch' do
      batch = described_class.create(
        shipments: [Fixture.one_call_buy_shipment],
      )
      batch.buy
      # Uncomment the following line if you need to re-record the cassette
      # sleep(1) # Wait enough time for the batch to process buying the shipment

      batch.label(
        file_format: 'ZPL',
      )

      # We can't assert anything meaningful here because the label gets queued for generation and may not be immediately available
      expect(batch).to be_an_instance_of(described_class)
    end
  end
end
