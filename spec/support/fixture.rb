# frozen_string_literal: true

require 'date'
require 'json'

class Fixture
  # Read fixture data from the fixtures JSON file
  def self.read_fixture_data
    current_dir = File.join(File.dirname(__FILE__), '../../')
    JSON.parse(File.read("#{current_dir}/examples/official/fixtures/client-library-fixtures.json"))
  end

  # We keep the page_size of retrieving `all` records small so cassettes stay small
  def self.page_size
    read_fixture_data['page_sizes']['five_results']
  end

  # This is the USPS carrier account ID that comes with your EasyPost account by default and should be used for all tests
  def self.usps_carrier_account_id
    # Fallback to the EasyPost Ruby Client Library Test User USPS carrier account ID due to strict matching
    ENV['USPS_CARRIER_ACCOUNT_ID'] || 'ca_716f33fd9fd348238b85c2922237f98b'
  end

  def self.usps
    read_fixture_data['carrier_strings']['usps']
  end

  def self.usps_service
    read_fixture_data['service_names']['usps']['first_service']
  end

  def self.pickup_service
    read_fixture_data['service_names']['usps']['pickup_service']
  end

  def self.report_type
    read_fixture_data['report_types']['shipment']
  end

  def self.report_date
    '2022-04-11'
  end

  def self.webhook_url
    read_fixture_data['webhook_url']
  end

  def self.ca_address1
    read_fixture_data['addresses']['ca_address_1']
  end

  def self.ca_address2
    read_fixture_data['addresses']['ca_address_2']
  end

  def self.incorrect_address
    read_fixture_data['addresses']['incorrect']
  end

  def self.basic_parcel
    read_fixture_data['parcels']['basic']
  end

  def self.basic_customs_item
    read_fixture_data['customs_items']['basic']
  end

  def self.basic_customs_info
    read_fixture_data['customs_infos']['basic']
  end

  def self.tax_identifier
    read_fixture_data['tax_identifiers']['basic']
  end

  def self.basic_shipment
    read_fixture_data['shipments']['basic_domestic']
  end

  def self.full_shipment
    read_fixture_data['shipments']['full']
  end

  def self.one_call_buy_shipment
    {
      to_address: ca_address1,
      from_address: ca_address2,
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
    pickup_date = '2022-09-29'

    pickup_data = read_fixture_data['pickups']['basic']
    pickup_data['min_datetime'] = pickup_date
    pickup_data['max_datetime'] = pickup_date

    pickup_data
  end

  def self.basic_carrier_account
    read_fixture_data['carrier_accounts']['basic']
  end

  # This fixture will require you to add a `tracking_code` key with a tracking code from a shipment
  def self.basic_insurance
    read_fixture_data['insurances']['basic']
  end

  def self.basic_order
    read_fixture_data['orders']['basic']
  end

  def self.event_json
    current_dir = File.join(File.dirname(__FILE__), '../../')
    data = File.read("#{current_dir}/examples/official/fixtures/event-body.json")

    JSON.parse(JSON.generate(data))
  end

  def self.event_bytes
    current_dir = File.join(File.dirname(__FILE__), '../../')
    data = File.open("#{current_dir}/examples/official/fixtures/event-body.json", &:readline)

    JSON.parse(data).to_json.encode('UTF-8')
  end

  # The credit card details below are for a valid proxy card usable
  # for tests only and cannot be used for real transactions.
  # DO NOT alter these details with real credit card information.
  def self.credit_card_details
    read_fixture_data['credit_cards']['test']
  end

  def self.rma_form_options
    read_fixture_data['form_options']['rma']
  end
end
