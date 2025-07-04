# frozen_string_literal: true

module EasyPost::Services
end

require_relative 'models'
require_relative 'services/base' # Must be imported first before the rest of child services
require_relative 'services/address'
require_relative 'services/api_key'
require_relative 'services/batch'
require_relative 'services/beta_rate'
require_relative 'services/beta_referral_customer'
require_relative 'services/billing'
require_relative 'services/carrier_account'
require_relative 'services/carrier_metadata'
require_relative 'services/carrier_type'
require_relative 'services/claim'
require_relative 'services/customs_info'
require_relative 'services/customs_item'
require_relative 'services/end_shipper'
require_relative 'services/event'
require_relative 'services/insurance'
require_relative 'services/luma'
require_relative 'services/order'
require_relative 'services/parcel'
require_relative 'services/pickup'
require_relative 'services/rate'
require_relative 'services/referral_customer'
require_relative 'services/refund'
require_relative 'services/report'
require_relative 'services/scan_form'
require_relative 'services/shipment'
require_relative 'services/smart_rate'
require_relative 'services/tracker'
require_relative 'services/user'
require_relative 'services/webhook'
