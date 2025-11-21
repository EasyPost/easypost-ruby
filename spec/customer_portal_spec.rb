# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CustomerPortal do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe 'customer portal' do
    it 'creates an account link' do
      user = client.user.all_children.children.first

      account_link = client.customer_portal.create_account_link(
        {
          session_type: 'account_onboarding',
          user_id: user.id,
          refresh_url: 'https://example.com/refresh',
          return_url: 'https://example.com/return',
        },
      )

      expect(account_link.object).to eq('CustomerPortalAccountLink')
    end
  end
end
