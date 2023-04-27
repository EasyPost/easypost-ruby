# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Shipment do
  let(:mock_shipment) { described_class.new('shp_123') }

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

    it 'creates a shipment when only IDs are used' do
      from_address = EasyPost::Address.create(Fixture.ca_address1)
      to_address = EasyPost::Address.create(Fixture.ca_address1)
      parcel = EasyPost::Parcel.create(Fixture.basic_parcel)

      shipment = described_class.create(
        {
          from_address: { id: from_address.id },
          to_address: { id: to_address.id },
          parcel: { id: parcel.id },
        },
      )

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.id).to match('shp_')
      expect(shipment.from_address.id).to match('adr_')
      expect(shipment.to_address.id).to match('adr_')
      expect(shipment.parcel.id).to match('prcl_')
      expect(shipment.from_address.street1).to eq('388 Townsend St')
    end

    it 'creates a shipment with carbon_offset' do
      shipment = described_class.create(Fixture.basic_shipment, nil, true)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.rates).not_to be_nil

      rate = shipment.rates.first
      expect(rate.carbon_offset).not_to be_nil
    end

    it 'creates a one-call-buy shipment with carbon_offset' do
      shipment = described_class.create(Fixture.one_call_buy_shipment, nil, true)

      carbon_offset_found = false
      shipment.fees.each do |fee|
        if fee.type == 'CarbonOffsetFee'
          carbon_offset_found = true
        end
      end
      expect(carbon_offset_found).to be true
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

    it 'stores the params used to retrieve the shipments' do
      shipments = described_class.all(
        page_size: Fixture.page_size,
        include_children: true,
        purchased: false,
      )

      expect(shipments.include_children).to be true
      expect(shipments.purchased).to be false
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.shipments.first.id
        next_page_first_id = next_page.shipments.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end

    it 'reuses the params used to retrieve the first page' do
      include_children = true
      purchased = false

      first_page = described_class.all(
        page_size: Fixture.page_size,
        include_children: include_children,
        purchased: purchased,
      )

      # No shipments match the above filters, so we need to mock up some fake results
      shipments = [described_class.new(id: 'shp_123')]

      next_page_params = described_class.build_next_page_params(first_page, shipments, 0)

      expect(next_page_params[:include_children]).to eq(include_children)
      expect(next_page_params[:purchased]).to eq(purchased)
    end
  end

  describe '.buy' do
    it 'buys a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment.buy(
        shipment.lowest_rate,
      )

      expect(shipment.postage_label).not_to be_nil
    end

    it 'buys a shipment with carbon offset' do
      shipment = described_class.create(Fixture.basic_shipment)

      shipment.buy(shipment.lowest_rate, true)

      carbon_offset_found = false
      shipment.fees.each do |fee|
        if fee.type == 'CarbonOffsetFee'
          carbon_offset_found = true
        end
      end
      expect(carbon_offset_found).to be true
    end

    it 'buys a shipment with carbon offset in params hash' do
      shipment = described_class.create(Fixture.basic_shipment)

      shipment.buy({ rate: shipment.lowest_rate, with_carbon_offset: true })

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.rates).not_to be_nil

      rate = shipment.rates.first
      expect(rate.carbon_offset).not_to be_nil
    end

    it 'buys a shipment with end_shipper_id' do
      end_shipper = EasyPost::EndShipper.create(Fixture.ca_address1)

      shipment = described_class.create(Fixture.basic_shipment)
      shipment.buy(shipment.lowest_rate, nil, end_shipper[:id])

      expect(shipment.postage_label).not_to be_nil
    end
  end

  describe '.regenerate_rates' do
    it 'regenerates rates for a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment = shipment.regenerate_rates

      rates_array = shipment.rates

      expect(rates_array).to be_an_instance_of(Array)
      expect(rates_array).to all(be_an_instance_of(EasyPost::Rate))
    end

    it 'regenerates rates for a shipment with carbon offset' do
      shipment = described_class.create(Fixture.basic_shipment)

      shipment_with_carbon_offset = shipment.regenerate_rates(true)

      shipment_with_carbon_offset.rates.each do |rate|
        expect(rate.carbon_offset).not_to be_nil
      end
    end
  end

  describe '.label' do
    it 'converts the label format of a shipment' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment.buy(
        shipment.lowest_rate,
      )

      shipment.label(
        file_format: 'ZPL',
      )

      expect(shipment.postage_label.label_zpl_url).not_to be_nil
    end

    it 'converts the label format of a shipment with unwrapped params' do
      shipment = described_class.create(Fixture.full_shipment)

      shipment.buy(
        shipment.lowest_rate,
      )

      shipment.label('ZPL')

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

    it 'insures a shipment with unwrapped params' do
      # If the shipment was purchased with a USPS rate, it must have had its insurance set to `0` when bought
      # so that USPS doesn't automatically insure it so we could manually insure it here.
      shipment_data = Fixture.one_call_buy_shipment
      shipment_data[:insurance] = 0

      shipment = described_class.create(shipment_data)

      shipment.insure(100)

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

  describe '.lowest_rate' do
    it 'tests various usage alterations of the lowest_rate method' do
      shipment = described_class.create(Fixture.full_shipment)

      # Test lowest rate with no filters
      lowest_rate = shipment.lowest_rate
      expect(lowest_rate.service).to eq('First')
      expect(lowest_rate.rate).to eq('5.57')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate with service filter (this rate is higher than the lowest but should filter)
      lowest_rate = shipment.lowest_rate([], ['Priority'])
      expect(lowest_rate.service).to eq('Priority')
      expect(lowest_rate.rate).to eq('7.90')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate with carrier filter (should error due to bad carrier)
      expect {
        shipment.lowest_rate(['BAD CARRIER'], [])
      }.to raise_error(EasyPost::Error, 'No rates found.')
    end

    it 'tests various usage alterations of the lowest_rate method when excluding params' do
      shipment = described_class.create(Fixture.full_shipment)

      # Test lowest rate by excluding a carrier (this is a weak test but we cannot assume existence of a non-USPS carrier)
      lowest_rate = shipment.lowest_rate(['!RandomCarrier'])
      expect(lowest_rate.service).to eq('First')
      expect(lowest_rate.rate).to eq('5.57')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate by excluding the `Priority` service
      lowest_rate = shipment.lowest_rate([], ['!Priority'])
      expect(lowest_rate.service).to eq('First')
      expect(lowest_rate.rate).to eq('5.57')
      expect(lowest_rate.carrier).to eq('USPS')
    end
  end

  describe '.lowest_smartrate' do
    it 'gets the lowest smartrate of a shipment' do
      shipment = described_class.create(Fixture.basic_shipment)

      # Test lowest smartrate with valid filters
      lowest_smartrate = shipment.lowest_smartrate(2, 'percentile_90')
      expect(lowest_smartrate['service']).to eq('First')
      expect(lowest_smartrate['rate']).to eq(5.57)
      expect(lowest_smartrate['carrier']).to eq('USPS')
    end

    it 'raises an error when no rates are found due to delivery_days' do
      shipment = described_class.create(Fixture.basic_shipment)

      # Test lowest smartrate with invalid filters (should error due to strict delivery_days)
      expect {
        shipment.lowest_smartrate(0, 'percentile_90')
      }.to raise_error(EasyPost::Error, 'No rates found.')
    end

    it 'raises an error when no rates are found due to delivery_accuracy' do
      shipment = described_class.create(Fixture.basic_shipment)

      # Test lowest smartrate with invalid filters (should error due to invalid delivery_accuracy)
      expect {
        shipment.lowest_smartrate(3, 'BAD_ACCURACY')
      }.to raise_error(EasyPost::Error)
    end
  end

  describe '.get_lowest_smartrate' do
    it 'gets the lowest smartrate from a list of smartrates' do
      shipment = described_class.create(Fixture.basic_shipment)
      smartrates = shipment.get_smartrates

      # Test lowest smartrate with valid filters
      lowest_smartrate = described_class.get_lowest_smartrate(smartrates, 2, 'percentile_90')
      expect(lowest_smartrate['service']).to eq('First')
      expect(lowest_smartrate['rate']).to eq(5.57)
      expect(lowest_smartrate['carrier']).to eq('USPS')
    end

    it 'raises an error when no rates are found due to delivery_days' do
      shipment = described_class.create(Fixture.basic_shipment)
      smartrates = shipment.get_smartrates

      # Test lowest smartrate with invalid filters (should error due to strict delivery_days)
      expect {
        described_class.get_lowest_smartrate(smartrates, 0, 'percentile_90')
      }.to raise_error(EasyPost::Error, 'No rates found.')
    end

    it 'raises an error when no rates are found due to delivery_accuracy' do
      shipment = described_class.create(Fixture.basic_shipment)
      smartrates = shipment.get_smartrates

      # Test lowest smartrate with invalid filters (should error due to invalid delivery_accuracy)
      expect {
        described_class.get_lowest_smartrate(smartrates, 3, 'BAD_ACCURACY')
      }.to raise_error(EasyPost::Error)
    end
  end

  describe '.generate_form' do
    it 'generates a form for a shipment' do
      shipment = described_class.create(Fixture.one_call_buy_shipment)
      form_type = 'return_packing_slip'

      shipment.generate_form(
        form_type,
        Fixture.rma_form_options,
      )

      expect(shipment.forms.count).to be > 0

      form = shipment.forms[0]

      expect(form.form_type).to eq(form_type)
      expect(form.form_url).not_to be_nil
    end
  end

  describe '.retrieve_estimated_delivery_date' do
    it 'retrieve time-in-transit data for each of the Rates of a shipment' do
      shipment = described_class.create(Fixture.full_shipment)
      estimated_delivery_dates = shipment.retrieve_estimated_delivery_date(Fixture.planned_ship_date)

      expect(estimated_delivery_dates.all? { |entry| entry['easypost_time_in_transit_data'] }).not_to be_nil
    end
  end
end
