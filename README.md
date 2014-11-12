# EasyPost Ruby Client Library

[<img src="https://circleci.com/gh/EasyPost/easypost-ruby.png?circle-token=80adb5236ed1fdce20810b055af79c63c3d5796b">](https://circleci.com/gh/EasyPost/easypost-ruby)


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
  :name => 'Sawyer Bateman',
  :street1 => '1A Larkspur Cres.',
  :city => 'St. Albert',
  :state => 'AB',
  :zip => 't8n2m4',
  :country => 'CA',
  :phone => '780-273-8374'
)
from_address = EasyPost::Address.create(
  :company => 'Simpler Postage Inc',
  :street1 => '388 Townsend Street',
  :street2 => 'Apt 20',
  :city => 'San Francisco',
  :state => 'CA',
  :zip => '94107',
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
