# EasyPost Ruby Client Library

[![Build Status](https://github.com/EasyPost/easypost-ruby/workflows/CI/badge.svg)](https://github.com/EasyPost/easypost-ruby/actions?query=workflow%3ACI)
[![Gem Version](https://badge.fury.io/rb/easypost.svg)](https://badge.fury.io/rb/easypost)

EasyPost, the simple shipping solution. You can sign up for an account at https://easypost.com.

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

API Documentation can be found at: https://easypost.com/docs/api.

## Development

```bash
# Install dependencies
bundle install

# Run tests (coverage is generated on a successful test suite run)
EASYPOST_TEST_API_KEY=123... EASYPOST_PROD_API_KEY=123... bundle exec rspec
```
