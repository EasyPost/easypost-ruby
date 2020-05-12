require 'spec_helper'

describe EasyPost::Webhook do
  let(:url) { "http://example.com" }
  let!(:webhook) { EasyPost::Webhook.create({url: url}) }

  context 'with automated cleanup' do
    after do
      webhook.delete()
    end

    describe '#create' do
      it 'creates' do
        expect(webhook.id).not_to       be_nil
        expect(webhook.url).to          eq(url)
        expect(webhook.mode).to         eq("test")
        expect(webhook.disabled_at).to  be_nil
        expect(webhook.class).to        eq(EasyPost::Webhook)
      end
    end

    describe '#retrieve' do
      it 'retrieves' do
        hook = EasyPost::Webhook.retrieve(webhook.id)

        expect(hook.id).to           eq(webhook.id)
        expect(hook.url).to          eq(url)
        expect(hook.mode).to         eq("test")
        expect(hook.disabled_at).to  be_nil
        expect(hook.class).to        eq(EasyPost::Webhook)
      end
    end

    describe '#index' do
      it 'indexes with the recently created webhook as the last one' do
        webhook
        webhooks = EasyPost::Webhook.all()

        hook = webhooks["webhooks"].last

        expect(hook.id).to           eq(webhook.id)
        expect(hook.url).to          eq(url)
        expect(hook.mode).to         eq("test")
        expect(hook.disabled_at).to  be_nil
        expect(hook.class).to        eq(EasyPost::Webhook)
      end
    end

    describe '#update' do
      it 'updates' do
        hook = webhook.update()

        expect(hook.id).to           eq(webhook.id)
        expect(hook.url).to          eq(url)
        expect(hook.mode).to         eq("test")
        expect(hook.disabled_at).to  be_nil
        expect(hook.class).to        eq(EasyPost::Webhook)
      end
    end
  end

  describe '#delete' do
    it 'deletes the tracker' do
      webhook.delete()

      begin
        EasyPost::Webhook.retrieve(webhook.id)
      rescue EasyPost::Error => e
        expect(e.http_status).to eq(404)
        expect(e.code).to        eq("NOT_FOUND")
        expect(e.message).to     eq("The requested resource could not be found.")
      end
    end
  end
end
