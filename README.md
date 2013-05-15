Installation
---------------

Clone this repository:

```
git clone git@github.com:EasyPost/easypost-ruby-beta.git
```

Build and install the gem:

```
gem build easypost.gemspec
gem install easypost-1.2.gem
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

Up-to-date documentation at: https://www.geteasypost.com/docs/v2

Tests
--------------------

```
rspec spec
```
