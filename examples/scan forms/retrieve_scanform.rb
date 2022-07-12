# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

scan_form = EasyPost::ScanForm.retrieve('sf_...')

puts scan_form
