require "spec_helper"

describe EasyPost::EasyPostObject do
  describe "#construct_from" do
    let(:shipment_json) do
      '{
        "batch_id": null,
        "batch_message": null,
        "batch_status": null,
        "buyer_address": {
          "carrier_facility": null,
          "city": "Kansas City",
          "company": "Airport Shipping",
          "country": "US",
          "created_at": "2020-05-22T17:25:38Z",
          "email": "kansas_shipping@example.com",
          "federal_tax_id": null,
          "id": "adr_16f040f4ab5c4622aeb7d789ac6a83f0",
          "mode": "test",
          "name": null,
          "object": "Address",
          "phone": "3149240383",
          "residential": false,
          "state": "MO",
          "state_tax_id": null,
          "street1": "123 Fake Street",
          "street2": null,
          "updated_at": "2020-05-22T17:25:42Z",
          "verifications": {
            "zip4": {
              "details": null,
              "errors": [],
              "success": true
            }
          },
          "zip": "64153-2054"
        },
        "created_at": "2020-05-22T17:25:40Z",
        "customs_info": null,
        "fees": [
          {
            "amount": "0.01000",
            "charged": true,
            "object": "Fee",
            "refunded": false,
            "type": "LabelFee"
          },
          {
            "amount": "39.65000",
            "charged": true,
            "object": "Fee",
            "refunded": false,
            "type": "PostageFee"
          }
        ],
        "forms": [],
        "from_address": {
          "carrier_facility": null,
          "city": "San Francisco",
          "company": "EasyPost",
          "country": "US",
          "created_at": "2020-05-22T17:25:39Z",
          "email": null,
          "federal_tax_id": null,
          "id": "adr_1bda69d4bc5f4f39b49200987a0bea79",
          "mode": "test",
          "name": null,
          "object": "Address",
          "phone": "4151234567",
          "residential": null,
          "state": "CA",
          "state_tax_id": null,
          "street1": "164 Townsend Street",
          "street2": "Unit 1",
          "updated_at": "2020-05-22T17:25:39Z",
          "verifications": {},
          "zip": "94107"
        },
        "id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
        "insurance": null,
        "is_return": false,
        "messages": [],
        "mode": "test",
        "object": "Shipment",
        "options": {
          "currency": "USD",
          "date_advance": 0,
          "payment": {
            "type": "SENDER"
          }
        },
        "order_id": null,
        "parcel": {
          "created_at": "2020-05-22T17:25:39Z",
          "height": 9.5,
          "id": "prcl_2fdeb2e1242c4db897afd7f8117c9888",
          "length": 16.5,
          "mode": "test",
          "object": "Parcel",
          "predefined_package": null,
          "updated_at": "2020-05-22T17:25:39Z",
          "weight": 40.1,
          "width": 12.0
        },
        "postage_label": {
          "created_at": "2020-05-22T17:25:43Z",
          "date_advance": 0,
          "id": "pl_7cdf3f43d299460cb9e99b8bddb58449",
          "integrated_form": "none",
          "label_date": "2020-05-22T17:25:43Z",
          "label_epl2_url": null,
          "label_file": null,
          "label_file_type": "image/png",
          "label_pdf_url": null,
          "label_resolution": 300,
          "label_size": "4x6",
          "label_type": "default",
          "label_url": "https://easypost-files.s3-us-west-2.amazonaws.com/files/postage_label/20200522/b40eae0624bb4ff09cf72581f4509d34.png",
          "label_zpl_url": null,
          "object": "PostageLabel",
          "updated_at": "2020-05-22T17:25:43Z"
        },
        "rates": [
          {
            "carrier": "USPS",
            "carrier_account_id": "ca_716f33fd9fd348238b85c2922237f98b",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": null,
            "delivery_date_guaranteed": false,
            "delivery_days": null,
            "est_delivery_days": null,
            "id": "rate_48aa4d1ceed44308a1017284d8ea29f2",
            "list_currency": "USD",
            "list_rate": "97.80",
            "mode": "test",
            "object": "Rate",
            "rate": "97.80",
            "retail_currency": "USD",
            "retail_rate": "114.65",
            "service": "Express",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "USPS",
            "carrier_account_id": "ca_716f33fd9fd348238b85c2922237f98b",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": null,
            "delivery_date_guaranteed": false,
            "delivery_days": 6,
            "est_delivery_days": 6,
            "id": "rate_c8420e3c5dec4843bea8fdaf74a871d9",
            "list_currency": "USD",
            "list_rate": "39.65",
            "mode": "test",
            "object": "Rate",
            "rate": "39.65",
            "retail_currency": "USD",
            "retail_rate": "39.65",
            "service": "ParcelSelect",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "USPS",
            "carrier_account_id": "ca_716f33fd9fd348238b85c2922237f98b",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": null,
            "delivery_date_guaranteed": false,
            "delivery_days": 2,
            "est_delivery_days": 2,
            "id": "rate_f27414f010e6402e8883333277486022",
            "list_currency": "USD",
            "list_rate": "39.95",
            "mode": "test",
            "object": "Rate",
            "rate": "39.95",
            "retail_currency": "USD",
            "retail_rate": "49.65",
            "service": "Priority",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-29T23:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 4,
            "est_delivery_days": 4,
            "id": "rate_12fa9d5b94a14b51b20bb3581ad8891d",
            "list_currency": "USD",
            "list_rate": "22.62",
            "mode": "test",
            "object": "Rate",
            "rate": "23.82",
            "retail_currency": "USD",
            "retail_rate": "32.79",
            "service": "Ground",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-28T23:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 3,
            "est_delivery_days": 3,
            "id": "rate_d102ef2f4fe54eae90529dd9a792bde1",
            "list_currency": "USD",
            "list_rate": "67.50",
            "mode": "test",
            "object": "Rate",
            "rate": "72.83",
            "retail_currency": "USD",
            "retail_rate": "63.73",
            "service": "3DaySelect",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-27T23:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 2,
            "est_delivery_days": 2,
            "id": "rate_d06e41d5cd694d779c579a63ab6144cd",
            "list_currency": "USD",
            "list_rate": "123.84",
            "mode": "test",
            "object": "Rate",
            "rate": "131.15",
            "retail_currency": "USD",
            "retail_rate": "111.29",
            "service": "2ndDayAirAM",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-27T23:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 2,
            "est_delivery_days": 2,
            "id": "rate_9a3966f05cd24ae282d107d7199934b1",
            "list_currency": "USD",
            "list_rate": "108.23",
            "mode": "test",
            "object": "Rate",
            "rate": "115.70",
            "retail_currency": "USD",
            "retail_rate": "97.29",
            "service": "2ndDayAir",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-26T23:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 1,
            "est_delivery_days": 1,
            "id": "rate_1fe13c17bded417e9cec96f4807d2a18",
            "list_currency": "USD",
            "list_rate": "164.57",
            "mode": "test",
            "object": "Rate",
            "rate": "175.93",
            "retail_currency": "USD",
            "retail_rate": "151.94",
            "service": "NextDayAirSaver",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-26T08:00:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 1,
            "est_delivery_days": 1,
            "id": "rate_265423513cdb4d2ba5223c678be51dda",
            "list_currency": "USD",
            "list_rate": "203.15",
            "mode": "test",
            "object": "Rate",
            "rate": "215.08",
            "retail_currency": "USD",
            "retail_rate": "201.33",
            "service": "NextDayAirEarlyAM",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          },
          {
            "carrier": "UPS",
            "carrier_account_id": "ca_e63ca9a0935f4adebd2b4f287f442f02",
            "created_at": "2020-05-22T17:25:42Z",
            "currency": "USD",
            "delivery_date": "2020-05-26T10:30:00Z",
            "delivery_date_guaranteed": false,
            "delivery_days": 1,
            "est_delivery_days": 1,
            "id": "rate_6b3f721c5be6484ab28d4f75386452bf",
            "list_currency": "USD",
            "list_rate": "172.85",
            "mode": "test",
            "object": "Rate",
            "rate": "184.78",
            "retail_currency": "USD",
            "retail_rate": "171.03",
            "service": "NextDayAir",
            "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
            "updated_at": "2020-05-22T17:25:42Z"
          }
        ],
        "reference": null,
        "refund_status": null,
        "return_address": {
          "carrier_facility": null,
          "city": "San Francisco",
          "company": "EasyPost",
          "country": "US",
          "created_at": "2020-05-22T17:25:39Z",
          "email": null,
          "federal_tax_id": null,
          "id": "adr_1bda69d4bc5f4f39b49200987a0bea79",
          "mode": "test",
          "name": null,
          "object": "Address",
          "phone": "4151234567",
          "residential": null,
          "state": "CA",
          "state_tax_id": null,
          "street1": "164 Townsend Street",
          "street2": "Unit 1",
          "updated_at": "2020-05-22T17:25:39Z",
          "verifications": {},
          "zip": "94107"
        },
        "scan_form": null,
        "selected_rate": {
          "carrier": "USPS",
          "carrier_account_id": "ca_716f33fd9fd348238b85c2922237f98b",
          "created_at": "2020-05-22T17:25:43Z",
          "currency": "USD",
          "delivery_date": null,
          "delivery_date_guaranteed": false,
          "delivery_days": 6,
          "est_delivery_days": 6,
          "id": "rate_c8420e3c5dec4843bea8fdaf74a871d9",
          "list_currency": "USD",
          "list_rate": "39.65",
          "mode": "test",
          "object": "Rate",
          "rate": "39.65",
          "retail_currency": "USD",
          "retail_rate": "39.65",
          "service": "ParcelSelect",
          "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
          "updated_at": "2020-05-22T17:25:43Z"
        },
        "status": "delivered",
        "to_address": {
          "carrier_facility": null,
          "city": "Kansas City",
          "company": "Airport Shipping",
          "country": "US",
          "created_at": "2020-05-22T17:25:38Z",
          "email": "kansas_shipping@example.com",
          "federal_tax_id": null,
          "id": "adr_16f040f4ab5c4622aeb7d789ac6a83f0",
          "mode": "test",
          "name": null,
          "object": "Address",
          "phone": "3149240383",
          "residential": false,
          "state": "MO",
          "state_tax_id": null,
          "street1": "601 Brasilia Avenue",
          "street2": null,
          "updated_at": "2020-05-22T17:25:42Z",
          "verifications": {
            "zip4": {
              "details": null,
              "errors": [],
              "success": true
            }
          },
          "zip": "64153-2054"
        },
        "tracker": {
          "carrier": "USPS",
          "carrier_detail": {
            "alternate_identifier": null,
            "container_type": null,
            "destination_location": "CHARLESTON SC, 29401",
            "destination_tracking_location": {
              "city": "CHARLESTON",
              "country": null,
              "object": "TrackingLocation",
              "state": "SC",
              "zip": "29407"
            },
            "est_delivery_date_local": null,
            "est_delivery_time_local": null,
            "guaranteed_delivery_date": null,
            "initial_delivery_attempt": "2020-04-25T07:19:43Z",
            "object": "CarrierDetail",
            "origin_location": "HOUSTON TX, 77001",
            "origin_tracking_location": {
              "city": "NORTH HOUSTON",
              "country": null,
              "object": "TrackingLocation",
              "state": "TX",
              "zip": "77315"
            },
            "service": "First-Class Package Service"
          },
          "created_at": "2020-05-22T17:25:43Z",
          "est_delivery_date": "2020-05-22T17:28:43Z",
          "fees": [],
          "id": "trk_6aebbf84a95e46d1bf180808c8548f01",
          "mode": "test",
          "object": "Tracker",
          "public_url": "https://track.easypost.com/djE6dHJrXzZhZWJiZjg0YTk1ZTQ2ZDFiZjE4MDgwOGM4NTQ4ZjAx",
          "shipment_id": "shp_6e5f072c9a5149f5917e72ef95f9cab1",
          "signed_by": "John Tester",
          "status": "delivered",
          "status_detail": "arrived_at_destination",
          "tracking_code": "9461200897846039483214",
          "tracking_details": [
            {
              "carrier_code": null,
              "datetime": "2020-04-22T17:28:43Z",
              "description": null,
              "message": "Pre-Shipment Info Sent to USPS",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "pre_transit",
              "status_detail": "status_update",
              "tracking_location": {
                "city": null,
                "country": null,
                "object": "TrackingLocation",
                "state": null,
                "zip": null
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-23T06:05:43Z",
              "description": null,
              "message": "Shipping Label Created",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "pre_transit",
              "status_detail": "status_update",
              "tracking_location": {
                "city": "HOUSTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "TX",
                "zip": "77063"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-23T16:10:43Z",
              "description": null,
              "message": "Arrived at USPS Origin Facility",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "in_transit",
              "status_detail": "arrived_at_facility",
              "tracking_location": {
                "city": "NORTH HOUSTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "TX",
                "zip": "77315"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-24T17:46:43Z",
              "description": null,
              "message": "Arrived at USPS Facility",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "in_transit",
              "status_detail": "arrived_at_facility",
              "tracking_location": {
                "city": "COLUMBIA",
                "country": null,
                "object": "TrackingLocation",
                "state": "SC",
                "zip": "29201"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-24T20:37:43Z",
              "description": null,
              "message": "Arrived at Post Office",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "in_transit",
              "status_detail": "arrived_at_facility",
              "tracking_location": {
                "city": "CHARLESTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "SC",
                "zip": "29407"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-25T02:17:43Z",
              "description": null,
              "message": "Sorting Complete",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "in_transit",
              "status_detail": "status_update",
              "tracking_location": {
                "city": "CHARLESTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "SC",
                "zip": "29407"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-25T02:27:43Z",
              "description": null,
              "message": "Out for Delivery",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "out_for_delivery",
              "status_detail": "out_for_delivery",
              "tracking_location": {
                "city": "CHARLESTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "SC",
                "zip": "29407"
              }
            },
            {
              "carrier_code": null,
              "datetime": "2020-04-25T07:19:43Z",
              "description": null,
              "message": "Delivered",
              "object": "TrackingDetail",
              "source": "USPS",
              "status": "delivered",
              "status_detail": "arrived_at_destination",
              "tracking_location": {
                "city": "CHARLESTON",
                "country": null,
                "object": "TrackingLocation",
                "state": "SC",
                "zip": "29407"
              }
            }
          ],
          "updated_at": "2020-05-22T17:28:44Z",
          "weight": null
        },
        "tracking_code": "9461200897846039483214",
        "updated_at": "2020-05-22T17:29:44Z",
        "usps_zone": 7
      }'
    end

    it "constructs actual objects from json string" do
      shipment = EasyPost::Shipment.construct_from(JSON.parse(shipment_json))
      expect(shipment).to be_a EasyPost::Shipment
      expect(shipment.rates).to all be_a EasyPost::Rate
    end

    context 'when the keys are symbols' do
      let(:rate) {
        EasyPost::Rate.construct_from(
          id: "rate_1234",
          object: "Rate",
          created_at: "2019-06-03T13:24:06Z",
          updated_at: "2019-06-03T13:24:06Z",
          mode: "test",
          service: "SMART_POST",
          carrier: "FedExSmartPost",
          rate: "687.23",
          currency: "USD",
          retail_rate: nil,
          retail_currency: nil,
          list_rate: "687.23",
          list_currency: "USD",
          delivery_days: 1,
          delivery_date: "2019-06-04T08:00:00Z",
          delivery_date_guaranteed: true,
          est_delivery_days: 1,
          shipment_id: "shp_1234",
          carrier_account_id: "ca_1234",
        )
      }

      it 'constructs the object and allows you to lookup the values' do
        expect(rate).to be_a EasyPost::Rate
        expect(rate['carrier_account_id']).to eq('ca_1234')
      end
    end
  end

  describe "#inspect" do
    specify do
      expect(
        described_class.construct_from({}).inspect
      ).to eq "#<EasyPost::EasyPostObject:> JSON: {}"
    end
  end

  describe "#to_s" do
    specify do
      expect(described_class.construct_from({}).to_s).to eq "{}"
    end
  end
end
