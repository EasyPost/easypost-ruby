# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

batch = EasyPost::Batch.retrieve('batch_...')

batch.buy

puts batch
