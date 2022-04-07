# frozen_string_literal: true

require 'date'
require 'json'

class Fixture
  # We keep the page_size of retrieving `all` records small so cassettes stay small
  def self.page_size
    5
  end

  # This is the USPS carrier account ID that comes with your EasyPost account by default and should be used for all tests
  def self.usps_carrier_account_id
    ENV['USPS_CARRIER_ACCOUNT_ID'] || 'ca_716f33fd9fd348238b85c2922237f98b' # Fallback to the EasyPost Ruby Client Library Test User USPS carrier account
  end

  def self.usps
    'USPS'
  end

  def self.usps_service
    'First'
  end

  def self.pickup_service
    'NextDay'
  end

  def self.report_type
    'shipment'
  end

  def self.report_start_date
    (Date.today - 2).to_s
  end

  def self.report_end_date
    Date.today.to_s
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
      street1: '417 montgomery streat',
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
  # USPS only does "next-day" pickups including Saturday but not Sunday or Holidays.
  def self.basic_pickup
    weekday_num = Date.today.wday
    weekday_offset = weekday_num == 5 ? 3 : 2 # Push our pickup date to the "next day" based on the day of the week
    pickup_date = (Date.today + weekday_offset).to_s

    {
      address: basic_address,
      min_datetime: pickup_date,
      max_datetime: pickup_date,
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

  def self.basic_insurance
    {
      from_address: basic_address,
      to_address: basic_address,
      carrier: usps,
      amount: '100',
    }
  end

  def self.basic_order
    {
      from_address: basic_address,
      to_address: basic_address,
      shipments: [basic_shipment],
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
