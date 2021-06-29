# CHANGELOG


## NEXT RELEASE

* Removed deprecated `Item` object
* Sorted EasyPost Resources list


## 3.3.0 2021-06-10

* Adds `SmartRate` functionality to the `Shipments` object (available by calling `get_smartrates` on a shipment)
* Fix bug where `EasyPost::CarrierAccount.types` was hitting the wrong endpoint


## 3.2.0 2021-01-14

* Replace Travis CI with Github Actions
* Add Ruby 3.0 to supported platforms (#110; thanks @maxwell)


## 3.1.5 2020-12-16

* Fix attribute lookup when manually constructing objects (#105; thanks @drewtempelmeyer)
* Flatten class names and clean up some other style issues
* Fix `EasyPost::Address.create_and_verify`, broken since 3.1.0 (#108; thanks @rajbirverma)


## 3.1.4 2020-09-29

* Don't modify params passed into Address#create (#78; thanks @TheRusskiy)
* Don't modify `carriers` and `services` parameters to `Shipment.lowest_rate` (#71 / #103, thanks @vladvinnikov and @jurisgalang)
* When constructing an easypost object, convert the key to a string (#102; thanks @Geesu)
* Expose the raw HTTP response as `#http_body` on `EasyPost::Error` objects (#101; thanks @Geesu)


## 3.1.3 2020-06-26

* Fix bug causing Authorization header to be included in User-Agent header. All users must upgrade.


## 3.1.2 2020-06-24

* Bad gem push. New version required.


## 3.1.1 2020-06-23

* Fix bug where EasyPost.http_config was invalid when not explicitly initialized.


## 3.1.0 2020-06-23

* Add Shipment Invoice and Refund Report
* Remove dependencies on `RestClient` and `MultiJson`
* Remove some deprecated endpoints


## 3.0.1 2018-05-17

* Enforce TLS certificate validity by default


## 3.0.0 2018-02-15

* Require use of ruby ~> 2.0 and TLSv1.2


## 2.7.3 2018-02-05

* Fix bug with introduced around certain JSON objects with IDs (thanks vladvinnikov!)


## 2.7.2 2018-02-01

* Removed unused and unsupported code paths for Container model
* Removed unused and unsupported code path for Stamp and Barcode methods on the Shipment model
* Fixed a bug with non-model JSON object with an "id" key being treated as models and raising errors


## 2.7.1 2017-05-25

* Allow reports to be retrieved without passing a type


## 2.7.0 2017-04-04

* Changed Report CRUD signatures. requires report type to be passed


## 2.6.2 2017-02-14

* Added get_rates method for Orders


## 2.6.1 2017-01-19

* Updated create method for ScanForms


## 2.6.0 2017-01-17

* Add basic CRUD methods for Webhooks


## 2.5.0 2016-12-19

* Add prefixes to report in utils


## 2.4.0 2016-12-08

* Add report resource to ruby client


## 2.3.0 2016-11-25

* Updated dependencies to allow rest-client 2.0.0 and above


## 2.2.0 2016-07-26

* Added standalone Insurance model


## 2.1.11 2016-02-04

* Allowed user creation for top-level users


## 2.1.10 2015-12-23

* Added verify and verify_strict params to Address.create
* Added Tracker.create_list and Tracker.all_updated for working with large
numbers of Trackers.


## 2.1.9 2015-11-04

* Added new tests for Tracker.all
* Updated some old examples


## 2.1.8 2015-10-21

* Added Cancel method for Pickups (thanks Ramie Blatt!)


## 2.1.7 2015-10-05

* Fixed Address.create_and_verify and changed how errors are raised (thanks Dimitri Roche!)
* Require newer version of the multi_json package


## 2.1.6 2015-06-10

* Added Address message accessor for backwards compatability


## 2.1.5 2015-06-10

* Removed Address.message


## 2.1.4 2015-06-03

* Add Printer and PrintJob resources.


## 2.1.3 2015-04-30

* Bux fix, EasyPost::Errors no longer break with a nil json body.


## 2.1.2 2015-04-29

* EasyPost::Errors now correctly parse field errors and error codes.


## 2.1.1 2015-04-15

* CarrierAccount will now correctly save in-place modifications to credentials
* Nested variables should now be saved correctly across all models
* Fixed version numbering confusion (the previous version was 2.0.15, not 2.1.0)


## 2.0.15 2015-04-15

* Added tracker to shipment buy response
* Updated tracker tests


## 2.0.14 2015-04-15

* Added User and CarrierAccount models with CRUD functionality


## 2.0.13 2014-10-30

* Added Pickup, PickupRate resources.
* Added ability to pass api_key to a few resources that were missing it.


## 2.0.12 2014-07-07

* Added Item, Container, and Order resources.
* Fixed and added a lot of tests.


## 2.0.11 2013-12-16

* Added Event.receive method for parsing events sent by webhook.
* Fixed tests to account for the tracking code returning and array of details instead of a Hash


## 2.0.10 2013-10-03

* API Addition: Event resource added for webhook consumption.


## 2.0.9 2013-09-19

* Interface Change: Changed batch.scan_form to batch.create_scan_form to support the ability to refer to scan forms associated to batches.


## 2.0.3 2013-07-31

* API Addition: Tracker resource added. Trackers can be used to register any tracking code with EasyPost webhooks.


## 2.0.2 2013-07-23

* API Addition: Shipment.track_with_code returns tracking details for any tracking code.


## 2.0.1 2013-07-07

* API Addition: Address.create_and_verify returns a verified address in one step.
* API Addition: Shipment.label forces the creation of additional label formats (pdf, epl2, zpl).
* API Addition: Shipment.insure purchases insurance for a shipment.
* Library Update: Added the ability to negatively filter carriers and services with Shipment.lowest_rate (e.g. '!usps').
