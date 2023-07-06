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

client = EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY'])

shipment = client.shipment.create(
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

bought_shipment = client.shipment.buy(shipment.id, rate: shipment.lowest_rate)

puts bought_shipment
```

### Custom Connections

Pass in a lambda function as `custom_client_exec` when initializing a client that responds to `call(method, uri, headers, open_timeout, read_timeout, body = nil)` where:

- `uri` is the fully-qualified URL of the EasyPost endpoint, including query parameters (`Uri` object)
- `method` is the lowercase name of the HTTP method being used for the request (e.g. `:get`, `:post`, `:put`, `:delete`)
- `headers` is a hash with all headers needed for the request pre-populated, including authorization (`Hash` object)
- `open_timeout` is the number of seconds to wait for the connection to open (integer)
- `read_timeout` is the number of seconds to wait for one block to be read (integer)
- `body` is a string of the body data to be included in the request, or nil (e.g. GET or DELETE request) (string or `nil`)

The lambda function should return an object with `code` and `body` attributes, where:

- `code` is the HTTP response status code (integer)
- `body` is the response body (string)

#### Faraday

```ruby
require 'faraday'

custom_connection = lambda { |method, uri, headers, _open_timeout, _read_timeout, body = nil|
  conn = Faraday.new(url: uri.to_s, headers: headers) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  conn.public_send(method, uri.path) { |request|
    request.body = body if body
  }.yield_self do |response|
    OpenStruct.new(code: response.status, body: response.body)
  end
}

my_client = described_class.new(
  api_key: ENV['EASYPOST_API_KEY'],
  custom_client_exec: custom_connection,
)
```

#### Typhoeus

```ruby
require 'typhoeus'

custom_connection = lambda { |method, uri, headers, _open_timeout, _read_timeout, body = nil|
  Typhoeus.public_send(
    method,
    uri.to_s,
    headers: headers,
    body: body,
  ).yield_self do |response|
    OpenStruct.new(code: response.code, body: response.body)
  end
}

my_client = described_class.new(
  api_key: ENV['EASYPOST_API_KEY'],
  custom_client_exec: custom_connection,
)
```

## Documentation

API documentation can be found at: <https://easypost.com/docs/api>.

Library documentation can be found on the web at: <https://easypost.github.io/easypost-ruby/> or by building them locally via the `make docs` command.

Upgrading major versions of this project? Refer to the [Upgrade Guide](UPGRADE_GUIDE.md).

## Support

New features and bug fixes are released on the latest major release of this library. If you are on an older major release of this library, we recommend upgrading to the most recent release to take advantage of new features, bug fixes, and security patches. Older versions of this library will continue to work and be available as long as the API version they are tied to remains active; however, they will not receive updates and are considered EOL.

For additional support, see our [org-wide support policy](https://github.com/EasyPost/.github/blob/main/SUPPORT.md).

## Development

```bash
# Install dependencies
make install

# Install style guide (Unix only)
make install-style

# Lint project
make lint
make lint-fix

# Run tests (coverage is generated on a successful test suite run)
EASYPOST_TEST_API_KEY=123... EASYPOST_PROD_API_KEY=123... make test

# Run security analysis
make scan

# Generate library documentation
make docs

# Update submodules
make update-examples-submodule
```

### Testing

The test suite in this project was specifically built to produce consistent results on every run, regardless of when they run or who is running them. This project uses [VCR](https://github.com/vcr/vcr) to record and replay HTTP requests and responses via "cassettes". When the suite is run, the HTTP requests and responses for each test function will be saved to a cassette if they do not exist already and replayed from this saved file if they do, which saves the need to make live API calls on every test run. If you receive errors about a cassette expiring, delete and re-record the cassette to ensure the data is up-to-date.

**Sensitive Data:** We've made every attempt to include scrubbers for sensitive data when recording cassettes so that PII or sensitive info does not persist in version control; however, please ensure when recording or re-recording cassettes that prior to committing your changes, no PII or sensitive information gets persisted by inspecting the cassette.

**Making Changes:** If you make an addition to this project, the request/response will get recorded automatically for you. When making changes to this project, you'll need to re-record the associated cassette to force a new live API call for that test which will then record the request/response used on the next run.

**Test Data:** The test suite has been populated with various helpful fixtures that are available for use, each completely independent from a particular user **with the exception of the USPS carrier account ID** (see [Unit Test API Keys](#unit-test-api-keys) for more information) which has a fallback value of our internal testing user's ID. Some fixtures use hard-coded dates that may need to be incremented if cassettes get re-recorded (such as reports or pickups).

#### Unit Test API Keys

The following are required on every test run:

- `EASYPOST_TEST_API_KEY`
- `EASYPOST_PROD_API_KEY`

Some tests may require an EasyPost user with a particular set of enabled features such as a `Partner` user when creating referrals. We have attempted to call out these functions in their respective docstrings. The following are required when you need to re-record cassettes for applicable tests:

- `USPS_CARRIER_ACCOUNT_ID` (eg: one-call buying a shipment for non-EasyPost employees)
- `PARTNER_USER_PROD_API_KEY` (eg: creating a referral customer)
- `REFERRAL_CUSTOMER_PROD_API_KEY` (eg: adding a credit card to a referral customer)
