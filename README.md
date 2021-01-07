# EasyPost Ruby Client Library

[![Build Status](https://github.com/EasyPost/easypost-ruby/workflows/CI/badge.svg)](https://github.com/EasyPost/easypost-ruby/actions?query=workflow%3ACI)
[![Gem Version](https://badge.fury.io/rb/easypost.svg)](https://badge.fury.io/rb/easypost)


EasyPost is a simple shipping API. You can sign up for an account at https://easypost.com

Installation
---------------

Install the gem:

```
gem install easypost
```

Import the EasyPost client in your application:

```
require 'easypost'
```

Example
------------------

```ruby
require 'easypost'
EasyPost.api_key = 'cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi'

to_address = EasyPost::Address.create(
  :name => 'Dr. Steve Brule',
  :street1 => '179 N Harbor Dr',
  :city => 'Redondo Beach',
  :state => 'CA',
  :zip => '90277',
  :country => 'US',
  :phone => '310-808-5243'
)
from_address = EasyPost::Address.create(
  :company => 'EasyPost',
  :street1 => '118 2nd Street',
  :street2 => '4th Floor',
  :city => 'San Francisco',
  :state => 'CA',
  :zip => '94105',
  :phone => '415-456-7890'
)

parcel = EasyPost::Parcel.create(
  :width => 15.2,
  :length => 18,
  :height => 9.5,
  :weight => 35.1
)

customs_item = EasyPost::CustomsItem.create(
  :description => 'EasyPost T-shirts',
  :quantity => 2,
  :value => 23.56,
  :weight => 33,
  :origin_country => 'us',
  :hs_tariff_number => 123456
)
customs_info = EasyPost::CustomsInfo.create(
  :integrated_form_type => 'form_2976',
  :customs_certify => true,
  :customs_signer => 'Dr. Pepper',
  :contents_type => 'gift',
  :contents_explanation => '', # only required when contents_type => 'other'
  :eel_pfc => 'NOEEI 30.37(a)',
  :non_delivery_option => 'abandon',
  :restriction_type => 'none',
  :restriction_comments => '',
  :customs_items => [customs_item]
)

shipment = EasyPost::Shipment.create(
  :to_address => to_address,
  :from_address => from_address,
  :parcel => parcel,
  :customs_info => customs_info
)

shipment.buy(
  :rate => shipment.lowest_rate
)

shipment.insure(amount: 100)

puts shipment.insurance

puts shipment.postage_label.label_url

```

Documentation
--------------------

Up-to-date documentation at: https://easypost.com/docs

Tests
--------------------

```
rspec spec
```
