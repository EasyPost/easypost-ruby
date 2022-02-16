# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Shipment do
  describe '.create' do
    it 'creates a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.id).to match('shp_')
      expect(shipment.rates).not_to be_nil
      expect(shipment.options.label_format).to eq('PNG')
      expect(shipment.options.invoice_number).to eq('123')
      expect(shipment.reference).to eq('123')
    end

    it 'creates a shipment with empty or nil objects and arrays' do
      shipment_data = Fixture.basic_shipment
      shipment_data[:customs_info] = []
      shipment_data[:options] = nil
      shipment_data[:tax_identifiers] = nil
      shipment_data[:reference] = ''

      shipment = described_class.create(shipment_data)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.id).to match('shp_')
      expect(shipment.options).not_to be_nil # The EasyPost API populates some default values here
      expect(shipment.customs_info).to be_nil
      expect(shipment.reference).to be_nil
    end

    it 'creates a shipment with tax_identifiers' do
      shipment_data = Fixture.basic_shipment
      shipment_data[:tax_identifiers] = [Fixture.tax_identifier]

      shipment = described_class.create(shipment_data)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.id).to match('shp_')
      expect(shipment.tax_identifiers[0].tax_id_type).to eq('IOSS')
    end
  end

  describe '.retrieve' do
    it 'retrieves a shipment' do
      shipment = described_class.create(Fixture.full_shipment)
      retrieved_shipment = described_class.retrieve(shipment.id)

      expect(retrieved_shipment).to be_an_instance_of(described_class)
      expect(retrieved_shipment.id).to eq(shipment.id)
    end
  end

  describe '.all' do
    it 'retrieves all shipments' do
      shipments = described_class.all(
        page_size: Fixture.page_size,
      )

      shipments_array = shipments.shipments

      expect(shipments_array.count).to be <= Fixture.page_size
      expect(shipments.has_more).not_to be_nil
      expect(shipments_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.buy' do
    it 'buys a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment.buy(
        rate: shipment.lowest_rate,
      )

      expect(shipment.postage_label).not_to be_nil
    end
  end

  describe '.regenerate_rates' do
    it 'regenerates rates for a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      rates = shipment.regenerate_rates

      rates_array = rates.rates

      expect(rates_array).to be_an_instance_of(Array)
      expect(rates_array).to all(be_an_instance_of(EasyPost::Rate))
    end
  end

  describe '.label' do
    it 'converts the label format of a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment.buy(
        rate: shipment.lowest_rate,
      )

      shipment.label(
        file_format: 'ZPL',
      )

      expect(shipment.postage_label.label_zpl_url).not_to be_nil
    end
  end

  describe '.insure' do
    it 'insures a shipment' do
      # If the shipment was purchased with a USPS rate, it must have had its insurance set to `0` when bought
      # so that USPS doesn't automatically insure it so we could manually insure it here.
      shipment_data = Fixture.one_call_buy_shipment
      shipment_data[:insurance] = 0

      shipment = described_class.create(shipment_data)

      shipment.insure(
        amount: '100',
      )

      expect(shipment.insurance).to eq('100.00')
    end
  end

  describe '.refund' do
    it 'refund a shipment' do
      # Refunding a test shipment must happen within seconds of the shipment being created as test shipments naturally
      # follow a flow of created -> delivered to cycle through tracking events in test mode - as such anything older
      # than a few seconds in test mode may not be refundable.
      shipment = described_class.create(Fixture.one_call_buy_shipment)

      shipment.refund

      expect(shipment.refund_status).to eq('submitted')
    end
  end

  describe '.get_smartrates' do
    it 'retrieves smartrates of a shipment' do
      shipment = described_class.create(Fixture.one_call_buy_shipment)

      expect(shipment.rates).not_to be_nil

      smartrates = shipment.get_smartrates

      expect(smartrates[0]['time_in_transit']['percentile_50']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_75']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_85']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_90']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_95']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_97']).not_to be_nil
      expect(smartrates[0]['time_in_transit']['percentile_99']).not_to be_nil
    end
  end
end
