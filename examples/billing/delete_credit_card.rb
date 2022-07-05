# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

deleted_credit_card = EasyPost::CreditCard.delete('card_...')

puts deleted_credit_card
