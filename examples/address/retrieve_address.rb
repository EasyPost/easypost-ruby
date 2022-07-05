require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

addresses = EasyPost::Address.all(
  page_size: 5
)

