# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Webhook do
  describe '.create' do
    it 'creates a webhook' do
      webhook = described_class.create(
        url: Fixture.webhook_url,
      )

      expect(webhook).to be_an_instance_of(described_class)
      expect(webhook.id).to match('hook_')
      expect(webhook.url).to eq(Fixture.webhook_url)

      # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
      webhook.delete
    end
  end

  describe '.retrieve' do
    it 'retrieves a webhook' do
      webhook = described_class.create(
        url: Fixture.webhook_url,
      )

      retrieved_webhook = described_class.retrieve(webhook.id)

      expect(retrieved_webhook).to be_an_instance_of(described_class)
      expect(retrieved_webhook.to_s).to eq(webhook.to_s)

      # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
      webhook.delete
    end
  end

  describe '.all' do
    it 'retrieves all webhooks' do
      webhooks = described_class.all(
        page_size: Fixture.page_size,
      )

      webhooks_array = webhooks.webhooks

      expect(webhooks_array.count).to be <= Fixture.page_size
      expect(webhooks_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.update' do
    it 'updates a webhook' do
      webhook = described_class.create(
        url: Fixture.webhook_url,
      )

      updated_webhook = webhook.update

      expect(updated_webhook).to be_an_instance_of(described_class)

      webhook.delete # Remove the webhook once we have tested it so we don't pollute the account with test webhooks
    end
  end

  describe '.delete' do
    it 'deletes a webhook' do
      webhook = described_class.create(
        url: Fixture.webhook_url,
      )

      response = webhook.delete

      expect(response).to be_an_instance_of(described_class)
    end
  end

  describe '.validate_webhook' do
    it 'validate a webhook' do
      webhook_secret = 'sécret'
      expected_hmac_signature = 'hmac-sha256-hex=e93977c8ccb20363d51a62b3fe1fc402b7829be1152da9e88cf9e8d07115a46b'
      headers = {
        'X-Hmac-Signature' => expected_hmac_signature,
      }

      webhook_body = described_class.validate_webhook(Fixture.webhook_body, headers, webhook_secret)
      expect(webhook_body['description']).to eq('batch.created')
    end

    it 'validate a webhook with invalid secret' do
      webhook_secret = 'invalid_secret'
      headers = {
        'X-Hmac-Signature' => 'some-signature',
      }

      expect {
        described_class.validate_webhook(Fixture.webhook_body, headers, webhook_secret)
      }.to raise_error(
        EasyPost::Error,
        'Webhook received did not originate from EasyPost or had a webhook secret mismatch.',
      )
    end

    it 'validate a webhook with missing secret' do
      webhook_secret = '123'
      headers = {
        'some-header' => 'some-signature',
      }

      expect {
        described_class.validate_webhook(Fixture.webhook_body, headers, webhook_secret)
      }.to raise_error(EasyPost::Error, 'Webhook received does not contain an HMAC signature.')
    end
  end
end
