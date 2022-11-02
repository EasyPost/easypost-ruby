# EasyPost Ruby Client Library

[![Build Status](https://github.com/EasyPost/easypost-ruby/workflows/CI/badge.svg)](https://github.com/EasyPost/easypost-ruby/actions?query=workflow%3ACI)
[![Coverage Status](https://coveralls.io/repos/github/EasyPost/easypost-ruby/badge.svg?branch=master)](https://coveralls.io/github/EasyPost/easypost-ruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/easypost.svg)](https://badge.fury.io/rb/easypost)

EasyPost, the simple shipping solution. You can sign up for an account at <https://easypost.com>.

## Install

```bash
gem install easypost
```

```ruby
# Require the library in your project:
require 'easypost'
```

## Usage

A simple create & buy shipment example:

```ruby
require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

shipment = EasyPost::Shipment.create(
  from_address: {
    company: 'EasyPost',
    street1: '118 2nd Street',
    street2: '4th Floor',
    city: 'San Francisco',
    state: 'CA',
    zip: '94105',
    phone: '415-456-7890',
  },
  to_address: {
    name: 'Dr. Steve Brule',
    street1: '179 N Harbor Dr',
    city: 'Redondo Beach',
    state: 'CA',
    zip: '90277',
    country: 'US',
    phone: '310-808-5243',
  },
  parcel: {
    width: 15.2,
    length: 18,
    height: 9.5,
    weight: 35.1,
  },
)

shipment.buy(rate: shipment.lowest_rate)

puts shipment
```

### Custom Connections

Set `EasyPost.default_connection` to an object that responds to `call(method, path, api_key = nil, body = nil)`

#### Faraday

```ruby
require 'faraday'
require 'faraday/response/logger'
require 'logger'

EasyPost.default_connection = lambda do |method, path, api_key = nil, body = nil|
  Faraday
    .new(url: EasyPost.api_base, headers: EasyPost.default_headers) { |builder|
      builder.use Faraday::Response::Logger, Logger.new(STDOUT), {bodies: true, headers: true}
      builder.adapter :net_http
    }
    .public_send(method, path) { |request|
      request.headers['Authorization'] = EasyPost.authorization(api_key)
      request.body = JSON.dump(EasyPost::Util.objects_to_ids(body)) if body
    }.yield_self { |response|
      EasyPost.parse_response(
        status: response.status,
        body: response.body,
        json: response.headers['Content-Type'].start_with?('application/json'),
      )
    }
end
```

#### Typhoeus

```ruby
require 'typhoeus'

EasyPost.default_connection = lambda do |method, path, api_key = nil, body = nil|
  Typhoeus.public_send(
    method,
    File.join(EasyPost.api_base, path),
    headers: EasyPost.default_headers.merge('Authorization' => EasyPost.authorization(api_key)),
    body: body.nil? ? nil : JSON.dump(EasyPost::Util.objects_to_ids(body)),
  ).yield_self { |response|
    EasyPost.parse_response(
      status: response.code,
      body: response.body,
      json: response.headers['Content-Type'].start_with?('application/json'),
    )
  }
end
```

## Documentation

API Documentation can be found at: <https://easypost.com/docs/api>.

## Development

```bash
# Install dependencies
make install

# Lint project
make lint

# Fix linting errors
make fix

# Run tests (coverage is generated on a successful test suite run)
EASYPOST_TEST_API_KEY=123... EASYPOST_PROD_API_KEY=123... make test

# Run security analysis
make scan

# Generate library documentation
make docs

# Update submodules
git submodule init
git submodule update --remote
```

### Testing

The test suite in this project was specifically built to produce consistent results on every run, regardless of when they run or who is running them. This project uses [VCR](https://github.com/vcr/vcr) to record and replay HTTP requests and responses via "cassettes". When the suite is run, the HTTP requests and responses for each test function will be saved to a cassette if they do not exist already and replayed from this saved file if they do, which saves the need to make live API calls on every test run.

**Sensitive Data:** We've made every attempt to include scrubbers for sensitive data when recording cassettes so that PII or sensitive info does not persist in version control; however, please ensure when recording or re-recording cassettes that prior to committing your changes, no PII or sensitive information gets persisted by inspecting the cassette.

**Making Changes:** If you make an addition to this project, the request/response will get recorded automatically for you. When making changes to this project, you'll need to re-record the associated cassette to force a new live API call for that test which will then record the request/response used on the next run.

**Test Data:** The test suite has been populated with various helpful fixtures that are available for use, each completely independent from a particular user **with the exception of the USPS carrier account ID** (see [Unit Test API Keys](#unit-test-api-keys) for more information) which has a fallback value of our internal testing user's ID. Some fixtures use hard-coded dates that may need to be incremented if cassettes get re-recorded (such as reports or pickups).

#### Unit Test API Keys

The following are required on every test run:

- `EASYPOST_TEST_API_KEY`
- `EASYPOST_PROD_API_KEY`

Some tests may require an EasyPost user with a particular set of enabled features such as a `Partner` user when creating referrals. We have attempted to call out these functions in their respective docstrings. The following are required when you need to re-record cassettes for applicable tests:

- `USPS_CARRIER_ACCOUNT_ID` (eg: one-call buying a shipment for non-EasyPost employees)
- `PARTNER_USER_PROD_API_KEY` (eg: creating a referral user)
- `REFERRAL_USER_PROD_API_KEY` (eg: adding a credit card to a referral user)
