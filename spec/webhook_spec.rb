# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Webhook do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a webhook' do
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
        webhook_secret: Fixture.webhook_secret,
      )

      expect(webhook).to be_an_instance_of(EasyPost::Models::Webhook)
      expect(webhook.id).to match('hook_')
      expect(webhook.url).to eq(Fixture.webhook_url)

      # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
      client.webhook.delete(webhook.id)
    end
  end

  describe '.retrieve' do
    it 'retrieves a webhook' do
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
      )

      retrieved_webhook = client.webhook.retrieve(webhook.id)

      expect(retrieved_webhook).to be_an_instance_of(EasyPost::Models::Webhook)
      expect(retrieved_webhook.to_s).to eq(webhook.to_s)

      # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
      client.webhook.delete(webhook.id)
    end
  end

  describe '.all' do
    it 'retrieves all webhooks' do
      webhooks = client.webhook.all(
        page_size: Fixture.page_size,
      )

      webhooks_array = webhooks.webhooks

      expect(webhooks_array.count).to be <= Fixture.page_size
      expect(webhooks_array).to all(be_an_instance_of(EasyPost::Models::Webhook))
    end
  end

  describe '.update' do
    it 'updates a webhook' do
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
      )

      updated_webhook = client.webhook.update(webhook.id, { webhook_secret: Fixture.webhook_secret })

      expect(updated_webhook).to be_an_instance_of(EasyPost::Models::Webhook)

      client.webhook.delete(webhook.id) # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
    end
  end

  describe '.delete' do
    it 'deletes a webhook' do
      webhook = client.webhook.create(
        url: Fixture.webhook_url,
      )

      expect { client.webhook.delete(webhook.id) }.not_to raise_error
    end
  end

  describe '.validate_webhook' do
    it 'validate a webhook' do
      headers = {
        'X-Hmac-Signature' => Fixture.webhook_hmac_signature,
      }

      webhook_body = EasyPost::Util.validate_webhook(Fixture.event_bytes, headers, Fixture.webhook_secret)
      expect(webhook_body['description']).to eq('tracker.updated')
      expect(webhook_body['result']['weight']).to eq(614.4) # Ensure we convert floats properly
    end

    it 'validate a webhook with invalid secret' do
      webhook_secret = 'invalid_secret'
      headers = {
        'X-Hmac-Signature' => 'some-signature',
      }

      expect {
        EasyPost::Util.validate_webhook(Fixture.event_bytes, headers, webhook_secret)
      }.to raise_error(
        EasyPost::Errors::SignatureVerificationError,
        EasyPost::Constants::WEBHOOK_SIGNATURE_MISMATCH,
      )
    end

    it 'validate a webhook with missing secret' do
      webhook_secret = '123'
      headers = {
        'some-header' => 'some-signature',
      }

      expect {
        EasyPost::Util.validate_webhook(Fixture.event_bytes, headers, webhook_secret)
      }.to raise_error(
        EasyPost::Errors::SignatureVerificationError,
        EasyPost::Constants::WEBHOOK_MISSING_SIGNATURE,
      )
    end
  end
end
