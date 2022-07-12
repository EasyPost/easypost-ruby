# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

scan_forms = EasyPost::ScanForm.all(
  { page_size: 2 },
)

puts scan_forms
