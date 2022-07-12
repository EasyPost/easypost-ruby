# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

event = EasyPost::Event.retrieve('evt_...')

puts event
