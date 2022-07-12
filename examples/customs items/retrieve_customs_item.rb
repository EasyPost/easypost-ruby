# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

customs_item = EasyPost::CustomsItem.retrieve('cstitem_...')

puts customs_item
