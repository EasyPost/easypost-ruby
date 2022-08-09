# frozen_string_literal: true

require 'date'
require 'json'

class Fixture
  # Read ficture data from the fixtures JSON file
  def self.read_fixture_data
    JSON.parse(File.read("./examples/official/fixtures/client-library-fixtures.json"))
  end

  # We keep the page_size of retrieving `all` records small so cassettes stay small
  def self.page_size
    self.read_fixture_data['page_sizes']['five_results']
  end

  # This is the USPS carrier account ID that comes with your EasyPost account by default and should be used for all tests
  def self.usps_carrier_account_id
    # Fallback to the EasyPost Ruby Client Library Test User USPS carrier account ID due to strict matching
    ENV['USPS_CARRIER_ACCOUNT_ID'] || 'ca_716f33fd9fd348238b85c2922237f98b'
  end

  def self.usps
    self.read_fixture_data['carrier_strings']['usps']
  end

  def self.usps_service
    self.read_fixture_data['service_names']['usps']['first_service']
  end

  def self.pickup_service
    self.read_fixture_data['service_names']['usps']['pickup_service']
  end

  def self.report_type
    self.read_fixture_data['report_types']['shipment']
  end

  def self.report_date
    '2022-04-11'
  end

  def self.webhook_url
    self.read_fixture_data['webhook_url']
  end

  def self.ca_address_1
    self.read_fixture_data['addresses']['ca_address_1']
  end

  def self.ca_address_2
    self.read_fixture_data['addresses']['ca_address_2']
  end

  def self.incorrect_address
    self.read_fixture_data['addresses']['incorrect']
  end

  def self.basic_parcel
    self.read_fixture_data['parcels']['basic']
  end

  def self.basic_customs_item
    self.read_fixture_data['customs_items']['basic']
  end

  def self.basic_customs_info
    self.read_fixture_data['customs_infos']['basic']
  end

  def self.tax_identifier
    self.read_fixture_data['tax_identifiers']['basic']
  end

  def self.basic_shipment
    self.read_fixture_data['shipments']['basic_domestic']
  end

  def self.full_shipment
    self.read_fixture_data['shipments']['full']
  end

  def self.one_call_buy_shipment
    {
      to_address: ca_address_1,
      from_address: ca_address_1,
      parcel: basic_parcel,
      service: usps_service,
      carrier_accounts: [usps_carrier_account_id],
      carrier: usps,
    }
  end

  # This fixture will require you to add a `shipment` key with a Shipment object from a test.
  # If you need to re-record cassettes, increment the date below and ensure it is one day in the future,
  # USPS only does "next-day" pickups including Saturday but not Sunday or Holidays.
  def self.basic_pickup
    pickup_date = '2022-08-11'

    pickup_data = self.read_fixture_data['pickups']['basic']
    pickup_data['min_datetime'] = pickup_date
    pickup_data['max_datetime'] = pickup_date

    return pickup_data
  end

  def self.basic_carrier_account
    self.read_fixture_data['carrier_accounts']['basic']
  end

  def self.basic_insurance
    self.read_fixture_data['insurances']['basic']
  end

  def self.basic_order
    self.read_fixture_data['orders']['basic']
  end

  def self.event
    self.read_fixture_data['event_body']
  end

  # The credit card details below are for a valid proxy card usable
  # for tests only and cannot be used for real transactions.
  # DO NOT alter these details with real credit card information.
  def self.credit_card_details
    self.read_fixture_data['credit_cards']['test']
  end

  def self.rma_form_options
    self.read_fixture_data['form_options']['rma']
  end
end
