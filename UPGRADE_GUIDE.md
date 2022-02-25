# Upgrade Guide

Use the following guide to assist in the upgrade process of the `easypost-ruby` library between major versions.

## Upgrading from 3.x to 4.0

### 4.0 High Impact Changes

* [Updating Dependencies](#40-updating-dependencies)

### 4.0 Medium Impact Changes

* [Removal of `get_rates` Shipment Method](#40-removal-of-getrates-shipment-method)

### 4.0 Low Impact Changes

* [Removal of `Print` and `PrintJob` Objects](#40-removal-of-print-and-printjob-objects)
* [Removal of `stamp_and_barcode_by_reference` Batch Method](#40-removal-of-stampandbarcodebyreference-batch-method)
* [Removal of `Address.verify` Parameters](#40-removal-of-addressverify-parameters)
* [Removal of the `http_status` Property on EasyPost::Error](#40-removal-of-httpstatus-property-on-easyposterror)

## 4.0 Updating Dependencies

Likelihood of Impact: High

**Ruby 2.5 Required**

easypost-ruby now requires Ruby 2.5 or greater.

**Dependencies**

No production dependencies were altered. Development dependencies were all bumped and `simplecov` and `rubocop` were introduced.

## 4.0 Removal of get_rates Shipment Method

Likelihood of Impact: Medium

The HTTP method used for the `get_rates` endpoint at the API level has changed from `POST` to `GET` and will only retrieve rates for a shipment instead of regenerating them. A new `/rerate` endpoint has been introduced to replace this functionality; In this library, you can now call the `Shipment.regenerate_rates` method to regenerate rates. Due to the logic change, the `get_rates` method has been removed since a Shipment inherently already has rates associated.

## 4.0 Removal of Print and PrintJob Objects

Likelihood of Impact: Low

The `Print` and `PrintJob` objects have been removed as they are no longer usable with the current version of the API.

## 4.0 Removal of stamp_and_barcode_by_reference Batch Method

Likelihood of Impact: Low

The `stamp_and_barcode_by_reference` Batch method has been removed as it is no longer usable with the current version of the API.

## 4.0 Removal of Address.verify Parameters

Likelihood of Impact: Low

The parameters for the `Address.verify` method were removed as they were unusable, the current version of the API does not allow you to verify an address by specifying a carrier.

## 4.0 Removal of http_status Property on EasyPost::Error

Likelihood of Impact: Low

The deprecated `http_status` property has been removed in favor of the `status` property on the EasyPost::Error object.
