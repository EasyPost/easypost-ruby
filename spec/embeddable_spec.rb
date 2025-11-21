# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Embeddable do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe 'embeddables' do
    it 'creates a session' do
      user = client.user.all_children.children.first

      session = client.embeddable.create_session(
        {
          origin_host: 'https://example.com',
          user_id: user.id,
        },
      )

      expect(session.object).to eq('EmbeddablesSession')
    end
  end
end
