# frozen_string_literal: true

module SupportAuthenticate
  def authenticate_prod_key
    EasyPost.api_key = ENV['EASYPOST_PROD_API_KEY']
  end

  def authenticate_partner_key
    EasyPost.api_key = ENV['PARTNER_USER_PROD_API_KEY'] || '123'
  end

  def authenticate_referral_key
    EasyPost.api_key = ENV['REFERRAL_CUSTOMER_PROD_API_KEY'] || '123'
  end

  def authenticate_test_key
    EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']
  end
end

RSpec.configure do |config|
  config.include(SupportAuthenticate)

  config.before do |e|
    if e.metadata[:authenticate_prod]
      authenticate_prod_key
    elsif e.metadata[:authenticate_partner]
      authenticate_partner_key
    elsif e.metadata[:authenticate_referral]
      authenticate_referral_key
    else
      authenticate_test_key
    end
  end
end
