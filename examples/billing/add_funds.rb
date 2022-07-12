# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

credit_card = EasyPost::CreditCard.fund('2000', 'primary')

puts credit_card
