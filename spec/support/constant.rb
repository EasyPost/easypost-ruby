ADDRESS = {
  california: {
    company: 'EasyPost',
    street1: '164 Townsend Street',
    street2: 'Unit 1',
    city: 'San Francisco',
    state: 'CA',
    zip: '94107',
    phone: '415-123-4567'
  },
  california_no_phone: {
    company: 'EasyPost',
    street1: '164 Townsend Street',
    street2: 'Unit 1',
    city: 'San Francisco',
    state: 'CA',
    zip: '94107'
  },
  missouri: {
    company: 'Airport Shipping',
    street1: '601 Brasilia Avenue',
    city: 'Kansas City',
    state: 'MO',
    zip: '64153',
    phone: '314-924-0383',
    email: 'kansas_shipping@example.com'
  },
  canada: {
    name: 'Sawyer Bateman',
    street1: '58 Larkspur Cres.',
    city: 'St. Albert',
    state: 'AB',
    zip: 'T8N2M4',
    country: 'CA',
    phone: '780-123-4567'
  },
  canada_no_phone: {
    name: 'Sawyer Bateman',
    street1: '58 Larkspur Cres.',
    city: 'St. Albert',
    state: 'AB',
    zip: 't8n2m4',
    country: 'CA',
    phone: '780-273-8374'
  }
}

PARCEL = {
  dimensions: {
    width: 12,
    length: 16.5,
    height: 9.5,
    weight: 40.1
  },
  dimensions_light: {
    width: 15.2,
    length: 18,
    height: 9.5,
    weight: 3
  },
  predefined_medium_flat_rate_box: {
    predefined_package: 'MediumFlatRateBox',
    weight: 17
  }
}

CUSTOMS_INFO = {
  shirt: {
    integrated_form_type: 'form_2976',
    customs_certify: true,
    customs_signer: 'Dr. Pepper',
    contents_type: 'gift',
    contents_explanation: '', # only required when contents_type: 'other'
    eel_pfc: 'NOEEI 30.37(a)',
    non_delivery_option: 'abandon',
    restriction_type: 'none',
    restriction_comments: '',
    customs_items: [{
      description: 'EasyPost T-shirts',
      quantity: 2,
      value: 23.56,
      weight: 20,
      origin_country: 'us',
      hs_tariff_number: 123456
    }]
  },
  merchandise: {
    customs_certify: true,
    customs_signer: 'Dr. Pepper',
    contents_type: 'merchandise',
    contents_explanation: '', # only required when contents_type: 'other'
    eel_pfc: 'NOEEI 30.37(a)',
    non_delivery_option: 'abandon',
    restriction_type: 'none',
    restriction_comments: ''
  }
}
