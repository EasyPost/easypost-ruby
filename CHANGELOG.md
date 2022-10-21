# CHANGELOG

## v4.8.1 (2022-10-24)

- Concatenates `error.message` if it incorrectly comes back from the API as an array
- Treats any HTTP status outside the `2xx` range as an error. Impact expected is minimal as this change only affects `1xx` and `3xx` HTTP status codes

## v4.8.0 (2022-09-21)

- Adds support to buy a shipment by passing in `end_shipper_id`
- `with_carbon_offset` can now alternatively be passed in the `params` parameter of the `shipment.buy` function
- Migrates Partner White Label (Referrals) to general library namespace and deprecates beta functions

## v4.7.1 (2022-09-06)

- Makes not implemented `all` calls match the `EasyPost::Resource` interface so that one can call `.to_json` on them and receive the proper error

## v4.7.0 (2022-08-25)

- Moves EndShipper out of beta to the general library namespace
- Ensure the Easypost object will respond to `.id` when it has one in `@values`

## v4.6.0 (2022-08-02)

- Adds Carbon Offset support
  - Adds ability to create a shipment with carbon_offset
  - Adds ability to buy a shipment with carbon_offset
  - Adds ability to one-call-buy a shipment with carbon_offset
  - Adds ability to rerate a shipment with carbon_offset
- Adds `validate_webhook` function that returns your webhook or raises an error if there is a `webhook_secret` mismatch
- Deprecated `PaymentMethod` class, please use `Billing` class for retrieve all payment method function

## v4.5.0 (2022-07-18)

- Adds ability to generate shipment forms via `generate_form` function

## v4.4.0 (2022-07-11)

- Adds `Billing.retrieve_payment_methods()`, `Billing.fund_wallet()`, and `Billing.delete_payment_method()` functions
- Captures OS information in the user-agent header for easier debugging
- Update functions now use `patch` instead of `put` under the hood to better match API behavior and documentation. The behavior of these functions should remain the same

## v4.3.0 (2022-05-19)

- Adds the `EndShipper` Beta class with `create`, `retrieve`, `all`, and `save` functions
- Requests will now fail fast with an error if an API key is not provided instead of making a live API call with no key
- Fixes a bug where the library could not properly parse the response of deleting a child user
- Fixes a bug where you could not update a webhook due to a `wrong number of arguments` error

## v4.2.1 (2022-05-11)

- Corrects the `Beta` namespace for the new Referral class

## v4.2.0 (2022-05-09)

- Adds a `lowest_rate()` function to Orders and Pickups
- Adds a `Shipment.get_lowest_smartrate()` function and a `shipment.lowest_smartrate()` function
- Removes the unusable `carrier` param from `Address.create_and_verify` along with the dead `message` conditional check
- Add beta Referral class for White Label API with these new functions: `create()`, `update_email()`, `all()`, and `add_credit_card()`

## v4.1.2 (2022-03-16)

- Rolls back the original connection behavior of establishing a new connection for every request (restores previous expectations for multithreaded implementations)

## v4.1.1 (2022-03-14)

- Fixes a bug that prematurely closed connections when using multithreading by wrapping requests in a mutex (closes #148)

## v4.1.0 (2022-03-09)

- Adds support for custom client connections (#142)
  - Reduces memory usage by reusing connections
- Extends all objects with `Enumerable` allowing for iterator patterns (#143)

## v4.0.0 (2022-02-25)

- Bumps minimum Ruby version from `2.2` to `2.5`
- Bumps dev dependencies
- Documents each interface of the project in code
- Overhauls the test suite with full coverage
- Introduces `Rubocop` and lints the entire project
- Removes the unusable `Print` and `PrintJob` objects
- Removes deprecated and unusable `stamp_and_barcode_by_reference` method on the Batch object
- Explicitly returns an error of "not implemented" for `Rate.all` and `Parcel.all`
- Removes the `Shipment.get_rates` function as shipments already contain rates. If you need to get new rates for a shipment, use the `Shipment.regenerate_rates` function instead
- Removes the parameters from `Address.verify` as they are unusable
- Removes the deprecated `http_status` property of the `EasyPost::Error` object as it was replaced with `status`
- Fixes a bug that would append an extra `id` field to each retrieved object
- Various other small improvements and bug fixes

## v3.5.0 (2021-12-06)

- Adds the `update_brand` method to the user object (closes #122)

## v3.4.0 (2021-07-13)

- Removed deprecated `Item` object
- Sorted EasyPost Resources list
- Remove 2015-vintage experimental `all_updated` method on Tracker
- Fixes API key retrieval (#120, thanks @andychongyz)
- Adds `regenerate_rates` method for new rerate API
- Adds `deconstruct_keys` method to allow for pattern matching on EasyPost objects

## v3.3.0 (2021-06-10)

- Adds `SmartRate` functionality to the `Shipments` object (available by calling `get_smartrates` on a shipment)
- Fix bug where `EasyPost::CarrierAccount.types` was hitting the wrong endpoint

## v3.2.0 (2021-01-14)

- Replace Travis CI with Github Actions
- Add Ruby 3.0 to supported platforms (#110; thanks @maxwell)

## v3.1.5 (2020-12-16)

- Fix attribute lookup when manually constructing objects (#105; thanks @drewtempelmeyer)
- Flatten class names and clean up some other style issues
- Fix `EasyPost::Address.create_and_verify`, broken since 3.1.0 (#108; thanks @rajbirverma)

## v3.1.4 (2020-09-29)

- Don't modify params passed into Address#create (#78; thanks @TheRusskiy)
- Don't modify `carriers` and `services` parameters to `Shipment.lowest_rate` (#71 / #103, thanks @vladvinnikov and @jurisgalang)
- When constructing an easypost object, convert the key to a string (#102; thanks @Geesu)
- Expose the raw HTTP response as `#http_body` on `EasyPost::Error` objects (#101; thanks @Geesu)

## v3.1.3 (2020-06-26)

- Fix bug causing Authorization header to be included in User-Agent header. All users must upgrade.

## v3.1.2 (2020-06-24)

- Bad gem push. New version required.

## v3.1.1 (2020-06-23)

- Fix bug where EasyPost.http_config was invalid when not explicitly initialized.

## v3.1.0 (2020-06-23)

- Add Shipment Invoice and Refund Report
- Remove dependencies on `RestClient` and `MultiJson`
- Remove some deprecated endpoints

## v3.0.1 (2018-05-17)

- Enforce TLS certificate validity by default

## v3.0.0 (2018-02-15)

- Require use of ruby ~> 2.0 and TLSv1.2

## v2.7.3 (2018-02-05)

- Fix bug with introduced around certain JSON objects with IDs (thanks vladvinnikov!)

## v2.7.2 (2018-02-01)

- Removed unused and unsupported code paths for Container model
- Removed unused and unsupported code path for Stamp and Barcode methods on the Shipment model
- Fixed a bug with non-model JSON object with an "id" key being treated as models and raising errors

## v2.7.1 (2017-05-25)

- Allow reports to be retrieved without passing a type

## v2.7.0 (2017-04-04)

- Changed Report CRUD signatures. requires report type to be passed

## v2.6.2 (2017-02-14)

- Added get_rates method for Orders

## v2.6.1 (2017-01-19)

- Updated create method for ScanForms

## v2.6.0 (2017-01-17)

- Add basic CRUD methods for Webhooks

## v2.5.0 (2016-12-19)

- Add prefixes to report in utils

## v2.4.0 (2016-12-08)

- Add report resource to ruby client

## v2.3.0 (2016-11-25)

- Updated dependencies to allow rest-client 2.0.0 and above

## v2.2.0 (2016-07-260

- Added standalone Insurance model

## v2.1.11 (2016-02-04)

- Allowed user creation for top-level users

## v2.1.10 (2015-12-23)

- Added verify and verify_strict params to Address.create
- Added Tracker.create_list and Tracker.all_updated for working with large
  numbers of Trackers.

## v2.1.9 (2015-11-04)

- Added new tests for Tracker.all
- Updated some old examples

## v2.1.8 (2015-10-21)

- Added Cancel method for Pickups (thanks Ramie Blatt!)

## v2.1.7 (2015-10-05)

- Fixed Address.create_and_verify and changed how errors are raised (thanks Dimitri Roche!)
- Require newer version of the multi_json package

## v2.1.6 (2015-06-10)

- Added Address message accessor for backwards compatability

## v2.1.5 (2015-06-10)

- Removed Address.message

## v2.1.4 (2015-06-03)

- Add Printer and PrintJob resources.

## v2.1.3 (2015-04-30)

- Bux fix, EasyPost::Errors no longer break with a nil json body.

## v2.1.2 (2015-04-29)

- EasyPost::Errors now correctly parse field errors and error codes.

## v2.1.1 (2015-04-15)

- CarrierAccount will now correctly save in-place modifications to credentials
- Nested variables should now be saved correctly across all models
- Fixed version numbering confusion (the previous version was 2.0.15, not 2.1.0)

## v2.0.15 (2015-04-15)

- Added tracker to shipment buy response
- Updated tracker tests

## v2.0.14 (2015-04-15)

- Added User and CarrierAccount models with CRUD functionality

## v2.0.13 (2014-10-30)

- Added Pickup, PickupRate resources.
- Added ability to pass api_key to a few resources that were missing it.

## v2.0.12 (2014-07-07)

- Added Item, Container, and Order resources.
- Fixed and added a lot of tests.

## v2.0.11 (2013-12-16)

- Added Event.receive method for parsing events sent by webhook.
- Fixed tests to account for the tracking code returning and array of details instead of a Hash

## v2.0.10 (2013-10-03)

- API Addition: Event resource added for webhook consumption.

## v2.0.9 (2013-09-19)

- Interface Change: Changed batch.scan_form to batch.create_scan_form to support the ability to refer to scan forms associated to batches.

## v2.0.3 (2013-07-31)

- API Addition: Tracker resource added. Trackers can be used to register any tracking code with EasyPost webhooks.

## v2.0.2 (2013-07-23)

- API Addition: Shipment.track_with_code returns tracking details for any tracking code.

## v2.0.1 (2013-07-07)

- API Addition: Address.create_and_verify returns a verified address in one step.
- API Addition: Shipment.label forces the creation of additional label formats (pdf, epl2, zpl).
- API Addition: Shipment.insure purchases insurance for a shipment.
- Library Update: Added the ability to negatively filter carriers and services with Shipment.lowest_rate (e.g. '!usps').

## v2.0.0 (2013-06-25)

## v1.1.3 (2013-06-05)

## v1.1.2 (2013-06-05)

## v1.1.1 (2013-02-12)

## v1.1.0 (2013-01-29)

## v1.0.8 (2012-11-19)

## v1.0.7 (2012-11-19)

## v1.0.6 (2012-11-19)

## v1.0.5 (2012-11-19)

## v1.0.4 (2012-11-14)

## v1.0.3 (2012-11-13)

## v1.0.2 (2012-11-13)

## v1.0.1 (2012-11-13)

## v1.0.0 (2012-11-02)
