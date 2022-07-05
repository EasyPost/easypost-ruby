# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

me = EasyPost::User.retrieve_me

me.recharge_threshold = '50.00'

me.save

puts me
