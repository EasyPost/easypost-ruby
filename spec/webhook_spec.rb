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
end
