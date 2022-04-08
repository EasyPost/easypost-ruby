# frozen_string_literal: true

require 'json'

class Fixture
  # We keep the page_size of retrieving `all` records small so cassettes stay small
  def self.page_size
    5
  end

  # This is the carrier account ID for the default USPS account that comes by default. All tests should use this carrier account
  def self.usps_carrier_account_id
    'ca_716f33fd9fd348238b85c2922237f98b'
  end

  def self.child_user_id
    'user_9d4d2aba00d44f1db487583c3967764f'
  end

  def self.usps
    'USPS'
  end

  def self.usps_service
    'First'
  end

  # If ever these need to change due to re-recording cassettes, simply increment this date by 1
  def self.report_start_date
    '2022-02-21'
  end

  # If ever these need to change due to re-recording cassettes, simply increment this date by 1
  def self.report_end_date
    '2022-02-23'
  end

  def self.basic_address
    {
      name: 'Jack Sparrow',
      company: 'EasyPost',
      street1: '388 Townsend St',
      street2: 'Apt 20',
      city: 'San Francisco',
      state: 'CA',
      zip: '94107',
      phone: '5555555555',
    }
  end

  def self.incorrect_address_to_verify
    {
      verify: [true],
      street1: '417 montgomery street',
      street2: 'FL 5',
      city: 'San Francisco',
      state: 'CA',
      zip: '94104',
      country: 'US',
      company: 'EasyPost',
      phone: '415-123-4567',
    }
  end

  def self.pickup_address
    {
      name: 'Dr. Steve Brule',
      street1: '179 N Harbor Dr',
      city: 'Redondo Beach',
      state: 'CA',
      zip: '90277',
      country: 'US',
      phone: '3331114444',
    }
  end

  def self.basic_parcel
    {
      length: '10',
      width: '8',
      height: '4',
      weight: '15.4',
    }
  end

  def self.basic_customs_item
    {
      description: 'Sweet shirts',
      quantity: 2,
      weight: 11,
      value: 23,
      hs_tariff_number: '654321',
      origin_country: 'US',
    }
  end

  def self.basic_customs_info
    {
      eel_pfc: 'NOEEI 30.37(a)',
      customs_certify: true,
      customs_signer: 'Steve Brule',
      contents_type: 'merchandise',
      contents_explanation: '',
      restriction_type: 'none',
      non_delivery_option: 'return',
      customs_items: [
        basic_customs_item,
      ],
    }
  end

  def self.tax_identifier
    {
      entity: 'SENDER',
      tax_id_type: 'IOSS',
      tax_id: '12345',
      issuing_country: 'GB',
    }
  end

  def self.basic_shipment
    {
      to_address: basic_address,
      from_address: basic_address,
      parcel: basic_parcel,
    }
  end

  def self.full_shipment
    {
      to_address: basic_address,
      from_address: basic_address,
      parcel: basic_parcel,
      customs_info: basic_customs_info,
      options: {
        label_format: 'PNG', # Must be PNG so we can convert to ZPL later
        invoice_number: '123',
      },
      reference: '123',
    }
  end

  def self.one_call_buy_shipment
    {
      to_address: basic_address,
      from_address: basic_address,
      parcel: basic_parcel,
      service: usps_service,
      carrier_accounts: [usps_carrier_account_id],
      carrier: usps,
    }
  end

  # This fixture will require you to add a `shipment` key with a Shipment object from a test.
  # If you need to re-record cassettes, simply iterate the dates below and ensure they're one day in the future,
  # USPS only does "next-day" pickups including Saturday but not Sunday or Holidays.
  def self.basic_pickup
    {
      address: basic_address,
      min_datetime: '2022-02-24',
      max_datetime: '2022-02-25',
      instructions: 'Pickup at front door',
    }
  end

  def self.basic_carrier_account
    {
      type: 'UpsAccount',
      credentials: {
        account_number: 'A1A1A1',
        user_id: 'USERID',
        password: 'PASSWORD',
        access_license_number: 'ALN',
      },
    }
  end

  def self.event
    JSON.generate(
      {
        mode: 'production',
        description: 'batch.created',
        previous_attributes: { state: 'purchasing' },
        pending_urls: ['example.com/easypost-webhook'],
        completed_urls: [],
        created_at: '2015-12-03T19:09:19Z',
        updated_at: '2015-12-03T19:09:19Z',
        result: {
          id: 'batch_...',
          object: 'Batch',
          mode: 'production',
          state: 'purchased',
          num_shipments: 1,
          reference: nil,
          created_at: '2015-12-03T19:09:19Z',
          updated_at: '2015-12-03T19:09:19Z',
          scan_form: nil,
          shipments: [
            {
              batch_status: 'postage_purchased',
              batch_message: nil,
              id: 'shp_123...',
            },
          ],
          status: {
            created: 0,
            queued_for_purchase: 0,
            creation_failed: 0,
            postage_purchased: 1,
            postage_purchase_failed: 0,
          },
          pickup: nil,
          label_url: nil,
        },
        id: 'evt_...',
        object: 'Event',
      },
    )
  end
end
