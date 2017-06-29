require 'spec_helper'

describe EasyPost::Rating do
	before do
		EasyPost.api_key = "STANDALONE RATING ENABLED KEY"
		carrieraccounts = ["CARRIERACCOUNTID"]
	end

	# describe '#create' do
	# 	it 'fetches rates' do
	# 		rt = EasyPost::Rating.create(
	# 		  to_address: {
	# 		    name: 'Dr. Steve Brule',
	# 		    street1: '179 N Harbor Dr',
	# 		    city: 'Redondo Beach',
	# 		    state: 'CA',
	# 		    zip: '90277',
	# 		    country: 'US',
	# 		    phone: '4155559999',
	# 		    email: 'dr_steve_brule@gmail.com'
	# 		  },
	# 		  from_address: {
	# 		    name: 'EasyPost',
	# 		    street1: '417 Montgomery Street',
	# 		    street2: '5th Floor',
	# 		    city: 'San Francisco',
	# 		    state: 'CA',
	# 		    zip: '94104',
	# 		    country: 'US',
	# 		    phone: '4155559999',
	# 		    email: 'support@easypost.com'
	# 		  },
	# 		  parcels: [{
	# 		    length: 20.2,
	# 		    width: 10.9,
	# 		    height: 5,
	# 		    weight: 65.9
	# 		  }],
	# 		  carrier_accounts: carrieraccounts
	# 		)
	# 		expect(rt).not_to be_nil
	# 	end 
	# end
end