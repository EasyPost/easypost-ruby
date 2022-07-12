# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

user = EasyPost::User.retrieve_me

user.recharge_threshold = '50.00'

user.save

puts user
