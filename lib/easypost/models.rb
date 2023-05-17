# frozen_string_literal: true

module EasyPost::Models
end

require_relative 'models/base' # Must be imported first before the rest of child models
require_relative 'models/address'
require_relative 'models/api_key'
require_relative 'models/batch'
require_relative 'models/brand'
require_relative 'models/carbon_offset'
require_relative 'models/carrier_account'
require_relative 'models/customs_info'
require_relative 'models/customs_item'
require_relative 'models/end_shipper'
require_relative 'models/event'
require_relative 'models/insurance'
require_relative 'models/order'
require_relative 'models/parcel'
require_relative 'models/payload'
require_relative 'models/payment_method'
require_relative 'models/pickup_rate'
require_relative 'models/pickup'
require_relative 'models/postage_label'
require_relative 'models/rate'
require_relative 'models/referral'
require_relative 'models/refund'
require_relative 'models/report'
require_relative 'models/scan_form'
require_relative 'models/shipment'
require_relative 'models/tax_identifier'
require_relative 'models/tracker'
require_relative 'models/user'
require_relative 'models/webhook'
