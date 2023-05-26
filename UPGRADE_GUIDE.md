# Upgrade Guide

Use the following guide to assist in the upgrade process of the `easypost-ruby` library between major versions.

- [Upgrading from 4.x to 5.0](#upgrading-from-4x-to-50)
- [Upgrading from 3.x to 4.0](#upgrading-from-3x-to-40)

## Upgrading from 4.x to 5.0

### 5.0 High Impact Changes

- [Thread-Safe With Client Object](#50-thread-safe-with-client-object)
- [Updated Dependencies](#50-updated-dependencies)
- [Improved Error Handling](#50-improved-error-handling)

### 5.0 Medium Impact Changes

- [Corrected Naming Conventions](#50-corrected-naming-conventions)

### 5.0 Low Impact Changes

- [Beta Namespace Changed](#50-beta-namespace-changed)

## 5.0 Thread-Safe with Client Object

Likelihood of Impact: High

This library is now thread-safe with the introduction of a new `Client` object. Instead of defining a global API key that all requests use, you now create an `Client` object and pass your API key to it with optional open and read timeout params. You then call your desired functions against a `service` which coincide with the `Client` object:

```ruby
# Old way
require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']
shipment = EasyPost::Shipment.retrieve('shp_...')

# New way
require 'easypost'

client = EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY'])
shipment = client.shipment.retrieve('shp_...')
```

All instance methods are now static with the exception of `lowest_rate` as these make API calls and require the EasyPostClient (EasyPost objects do not contain an API key to make API calls with).

Previously used `.save()` instance methods are now static `.update()` functions where you specify first the ID of the object you are updating and second, the parameters that need updating.

Functions no longer accept an API key as an optional parameter. If you need per-function API key changes, create a new EasyPostClient object and call the function on the new client that uses the API key you need.

## 5.0 Updated Dependencies

Likelihood of Impact: High

**Ruby 2.6 Required**

easypost-ruby now requires Ruby 2.6 or greater.

**Dependencies**

All dependencies had minor version bumps.

## 5.0 Improved Error Handling

Likelihood of Impact: High

There are ~2 dozen new error types that extend either `ApiError` or `EasyPostError`.

New ApiErrors (extends EasyPostError):

- `ApiError`
- `ConnectionError`
- `ExternalApiError`
- `ForbiddenError`
- `GatewayTimeoutError`
- `InternalServerError`
- `InvalidRequestError`
- `MethodNotAllowedError`
- `NotFoundError`
- `PaymentError`
- `ProxyError`
- `RateLimitError`
- `RedirectError`
- `RetryError`
- `ServiceUnavailableError`
- `SSLError`
- `TimeoutError`
- `UnauthorizedError`
- `UnknownApiError`

New EasyPostErrors (extends builtin Exception):

- `EasyPostError`
- `EndOfPaginationError`
- `FilteringError`
- `InvalidObjectError`
- `InvalidParameterError`
- `MissingParameterError`
- `SignatureVerificationError`

ApiErrors will behave like the previous Error class did. They will include a `message`, `http_status`, and `http_body`. Additionally, a new `code` and `errors` keys are present and populate when available. This class extends the more generic `EasyPostError` which only contains a message, used for errors thrown directly from this library.

## 5.0 Corrected Naming Conventions

Likelihood of Impact: Medium

Occurances of `referral` are now `referral_customer` and `Referral` are now `ReferralCustomer` to match the documentation and API.

Occurances of `smartrate` are now `smart_rate` and `Smartrate` are now `SmartRate` to match the documentation and API.

Occurances of `scanform` are now `scan_form` and `Scanform` are now `ScanForm` to match the documentation and API.

Rename function `get_smartrates` to `get_smart_rates`

Rename function `get_lowest_smartrate` to `get_lowest_smart_rate`

## 5.0 Beta Namespace Changed

Likelihood of Impact: Low

Previously, the beta namespace was found at `easypost.beta.x` where `x` is the name of your model. Now, the beta namespace is simply prepended to the name of your service: `client.beta_x`. for instance, you can call `client.beta_referral_customer.add_payment_method()`.

## 5.0 Return True For Empty API Response

Likelihood of Impact: Low

Empty API response functions for `delete` return `true` instead of empty object

## Upgrading from 3.x to 4.0

**NOTICE:** v4 is deprecated.

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
