# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

payment_methods = EasyPost::PaymentMethod.all

puts payment_methods
