# frozen_string_literal: true

module SupportAuthenticate
  def authenticate_test_key
    EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']
  end

  def authenticate_prod_key
    EasyPost.api_key = ENV['EASYPOST_PROD_API_KEY']
  end
end

RSpec.configure do |config|
  config.include(SupportAuthenticate)

  config.before { |e| e.metadata[:authenticate_prod] ? authenticate_prod_key : authenticate_test_key }
end
