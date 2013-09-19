require 'easypost'
EasyPost.api_key = 'cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi'
# EasyPost.api_base = 'http://localhost:5000/v2'

def address_canada
  address = EasyPost::Address.create(
    :name => 'Sawyer Bateman',
    :street1 => '1A Larkspur Cres.',
    :city => 'St. Albert',
    :state => 'AB',
    :zip => 't8n2m4',
    :country => 'CA',
    :phone => '780-273-8374'
  )
  return address
end

def address_california
  address = EasyPost::Address.create(
    :company => 'Simpler Postage Inc',
    :street1 => '388 Townsend Street',
    :street2 => 'Apt 20',
    :city => 'San Francisco',
    :state => 'CA',
    :zip => '94107',
    :phone => '415-456-7890'
  )
  return address
end

def address_missouri
  address = EasyPost::Address.create(
    :company => 'Airport Shipping',
    :street1 => '601 Brasilia Avenue',
    :city => 'Kansas City',
    :state => 'MO',
    :zip => '64153',
    :phone => '314-924-0383',
    :email => 'kansas_shipping@example.com'
  )
  return address
end

def parcel_dimensions
  parcel = EasyPost::Parcel.create(
    :width => 15.2,
    :length => 18,
    :height => 9.5,
    :weight => 35.1
  )
  return parcel
end

def parcel_package
  parcel = EasyPost::Parcel.create(
    :predefined_package => 'MediumFlatRateBox',
    :weight => 17
  )
  return parcel
end

def customs_info_poor
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
  return customs_info
end
