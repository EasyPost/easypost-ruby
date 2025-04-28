# Upgrade Guide

Use the following guide to assist in the upgrade process of the `easypost-ruby` library between major versions.

- [Upgrading from 6.x to 7.0](#upgrading-from-6x-to-70)
- [Upgrading from 5.x to 6.0](#upgrading-from-5x-to-60)
- [Upgrading from 4.x to 5.0](#upgrading-from-4x-to-50)
- [Upgrading from 3.x to 4.0](#upgrading-from-3x-to-40)

## Upgrading from 6.x to 7.0

### 7.0 High Impact Changes

- [Error Parsing](#70-error-parsing)

### 7.0 Medium Impact Changes

- [Deprecations](#70-deprecations)

## 7.0 Error Parsing

*Likelihood of Impact: **High***

The `errors` key of an error response can return either a list of `FieldError` objects or a list of strings. The error parsing has been expanded to include both formats. As such, you will now need to check for the format of the `errors` field and handle the errors appropriately for the type that is returned.

The `Error` model has been removed since it is unused and we directly assign properties of an error response to the `ApiError` type.

The `code` and `field` properties of an `EasyPostError` have been removed as they only belong to the `ApiError` type.

## 7.0 Deprecations

*Likelihood of Impact: **Medium***

The following deprecated functions have been removed:

- `tracker.create_list` (trackers must be created individually moving forward)
- `user.all_api_keys` (use `api_key.all`)
- `user.api_keys` (use `api_key.retrieve_api_keys_for_user`)

The `irb` has been removed from this library.

## Upgrading from 5.x to 6.0

**NOTICE:** v6 is deprecated.

### 6.0 High Impact Changes

- [Carbon Offset Removed](#60-carbon-offset-removed)

### 6.0 Low Impact Changes

- [Create and Buy Batch Function Removed](#60-create-and-buy-batch-function-removed)

## 6.0 Carbon Offset Removed

*Likelihood of Impact: **High***

EasyPost now offers Carbon Neutral shipments by default for free! Because of this, there is no longer a need to specify if you want to offset the carbon footprint of a shipment.

The `with_carbon_offset` parameter of the `create`, `buy`, and `regenerate_rates` shipment functions has been removed.

This is a high-impact change for those using `EndShippers`, as the signature for the `create` and `buy` shipment function has changed. You will need to inspect these callsites to ensure that the EndShipper parameter is being passed in the correct place.

## 6.0 Create and Buy Batch Function Removed

*Likelihood of Impact: **Low***

The `create_and_buy` batch endpoint has been deprecated, and the `create_and_buy` Batch service function has been removed.

The correct procedure is to first create a batch and then purchase it with two separate API calls.

## Upgrading from 4.x to 5.0

**NOTICE:** v5 is deprecated.

### 5.0 High Impact Changes

- [New Client object](#50-thread-safe-with-client-object)
- [Updated Dependencies](#50-updated-dependencies)
- [Improved Error Handling](#50-improved-error-handling)

### 5.0 Medium Impact Changes

- [Corrected Naming Conventions](#50-corrected-naming-conventions)

### 5.0 Low Impact Changes

- [Beta Namespace Changed](#50-beta-namespace-changed)

## 5.0 Thread-Safe with Client Object

Likelihood of Impact: High

This library is now thread-safe with the introduction of a new `Client` object. Instead of defining a global API key that all requests use, you now create an `Client` object and pass your API key to it with optional open and read timeout params. You then call your desired functions against a `service` which are called against a `Client` object:

```ruby
# Old way
EasyPost.api_key = ENV['EASYPOST_API_KEY']
shipment = EasyPost::Shipment.retrieve('shp_...')

# New way
client = EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY'])
shipment = client.shipment.retrieve('shp_...')
```

All instance methods are now static with the exception of `lowest_rate` as these make API calls and require the Client object(EasyPost objects do not contain an API key to make API calls with).

Previously used `.save()` instance methods are now static `.update()` functions where you specify first the ID of the object you are updating and second, the parameters that need updating.

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

- [Updating Dependencies](#40-updating-dependencies)

### 4.0 Medium Impact Changes

- [Removal of `get_rates` Shipment Method](#40-removal-of-getrates-shipment-method)

### 4.0 Low Impact Changes

- [Removal of `Print` and `PrintJob` Objects](#40-removal-of-print-and-printjob-objects)
- [Removal of `stamp_and_barcode_by_reference` Batch Method](#40-removal-of-stampandbarcodebyreference-batch-method)
- [Removal of `Address.verify` Parameters](#40-removal-of-addressverify-parameters)
- [Removal of the `http_status` Property on EasyPost::Error](#40-removal-of-httpstatus-property-on-easyposterror)

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
