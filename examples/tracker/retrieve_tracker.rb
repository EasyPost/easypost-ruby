# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

tracker = EasyPost::Tracker.retrieve('trk_...')

puts tracker
