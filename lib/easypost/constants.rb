# frozen_string_literal: true

class EasyPost::Constants
  API_ERROR_DETAILS_PARSING_ERROR = 'API error details could not be parsed.'
  INVALID_PARAMETER = '%s is not a valid parameter.'
  INVALID_PAYMENT_METHOD = 'The chosen payment method is not valid. Please try again.'
  MISSING_REQUIRED_PARAMETER = 'Required parameter %s is missing.'
  NO_MATCHING_RATES = 'No matching rates found.'
  NO_USER_FOUND = 'No user found with the given id.'
  NO_MORE_PAGES = 'There are no more pages to retrieve.'
  NO_PAYMENT_METHODS = 'Billing has not been setup for this user. Please add a payment method.'
  STRIPE_CARD_CREATE_FAILED = 'Could not send card details to Stripe, please try again later.'
  UNEXPECTED_HTTP_STATUS_CODE = 'Unexpected HTTP status code received: %s'
  WEBHOOK_MISSING_SIGNATURE = 'Webhook received does not contain an HMAC signature.'
  WEBHOOK_SIGNATURE_MISMATCH = 'Webhook received did not originate from EasyPost or had a webhook secret mismatch.'
end
