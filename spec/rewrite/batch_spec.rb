# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Services::Batch do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe 'batch service' do
    it 'create a batch' do
      batch = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      expect(batch).to be_an_instance_of(EasyPost::Models::Batch)
      expect(batch.id).to match('batch_')
      expect(batch.shipments).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves a batch' do
      batch = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )
      retrieved_batch = client.batch.retrieve(batch.id)

      expect(retrieved_batch).to be_an_instance_of(EasyPost::Models::Batch)
      expect(retrieved_batch.id).to eq(batch.id)
    end
  end

  describe '.all' do
    it 'retrieves all batches' do
      batches = client.batch.all(
        page_size: Fixture.page_size,
      )

      batch_array = batches.batches

      expect(batch_array.count).to be <= Fixture.page_size
      expect(batches.has_more).not_to be_nil
      expect(batch_array).to all(be_an_instance_of(EasyPost::Models::Batch))
    end
  end

  describe '.create_and_buy' do
    it 'creates and buys a batch in a single call' do
      batch = client.batch.create_and_buy(
        shipments: [
          Fixture.one_call_buy_shipment,
          Fixture.one_call_buy_shipment,
        ],
      )

      expect(batch).to be_an_instance_of(EasyPost::Models::Batch)
      expect(batch.id).to match('batch_')
      expect(batch.num_shipments).to eq(2)
    end
  end

  describe '.buy' do
    it 'buys a batch' do
      batch = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      bought_batch = client.batch.buy(batch.id)

      expect(bought_batch).to be_an_instance_of(EasyPost::Models::Batch)
      expect(bought_batch.num_shipments).to eq(1)
    end
  end

  describe '.create_scan_form' do
    it 'creates a scanform for a batch', :vcr do
      batch = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      bought_batch = client.batch.buy(batch.id)

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait enough time for the batch to process buying the shipment
      end

      batch_with_scan_form = client.batch.create_scan_form(bought_batch.id)

      # We can't assert anything meaningful here because the scanform gets queued for generation and may not be immediately available
      expect(batch_with_scan_form).to be_an_instance_of(EasyPost::Models::Batch)
    end
  end

  describe 'add and remove shipments' do
    it 'adds and removes shipments from a batch' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      batch = client.batch.create

      batch_with_shipment = client.batch.add_shipments(
        batch.id,
        shipment: [{ id: shipment.id }],
      )
      expect(batch_with_shipment.num_shipments).to eq(1)

      batch_without_shipment = client.batch.remove_shipments(
        batch_with_shipment.id,
        shipment: [{ id: shipment.id }],
      )
      expect(batch_without_shipment.num_shipments).to eq(0)
    end
  end

  describe '.label' do
    it 'generates a label for a batch', :vcr do
      batch = client.batch.create(
        shipments: [Fixture.one_call_buy_shipment],
      )

      bought_batch = client.batch.buy(batch.id)

      unless File.file?(VCR.current_cassette.file)
        sleep(5) # Wait enough time for the batch to process buying the shipment
      end

      batch_with_label = client.batch.label(bought_batch.id, { file_format: 'ZPL' })

      # We can't assert anything meaningful here because the label gets queued for generation and may not be immediately available
      expect(batch_with_label).to be_an_instance_of(EasyPost::Models::Batch)
    end
  end
end
