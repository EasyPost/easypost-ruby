# frozen_string_literal: true

# Each Webhook contains the url which EasyPost will notify whenever an object in our system updates. Several types of objects are processed
# asynchronously in the EasyPost system, so whenever an object updates, an Event is sent via HTTP POST to each configured webhook URL.
class EasyPost::Webhook < EasyPost::Resource
  # Update a Webhook.
  def update(params = {})
    # NOTE: This method is redefined here since the "url" method conflicts with the objects field
    unless id
      raise EasyPost::Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}")
    end

    instance_url = "#{self.class.url}/#{CGI.escape(id)}"

    response = EasyPost.make_request(:patch, instance_url, @api_key, params)
    refresh_from(response, api_key)

    self
  end

  # Delete a Webhook.
  def delete
    # NOTE: This method is redefined here since the "url" method conflicts with the objects field
    unless id
      raise EasyPost::Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}")
    end

    instance_url = "#{self.class.url}/#{CGI.escape(id)}"

    response = EasyPost.make_request(:delete, instance_url, @api_key)
    refresh_from(response, api_key)

    self
  end

  # Validate a webhook by comparing the HMAC signature header sent from EasyPost to your shared secret.
  # If the signatures do not match, an error will be raised signifying the webhook either did not originate
  # from EasyPost or the secrets do not match. If the signatures do match, the `event_body` will be returned
  # as JSON.
  def self.validate_webhook(event_body, headers, webhook_secret)
    easypost_hmac_signature = headers['X-Hmac-Signature']

    if easypost_hmac_signature.nil?
      raise EasyPost::Error.new('Webhook received does not contain an HMAC signature.')
    end

    encoded_webhook_secret = webhook_secret.unicode_normalize(:nfkd).encode('utf-8')

    expected_signature = OpenSSL::HMAC.hexdigest('sha256', encoded_webhook_secret, event_body)
    digest = "hmac-sha256-hex=#{expected_signature}"
    unless digest == easypost_hmac_signature
      raise EasyPost::Error.new('Webhook received did not originate from EasyPost or had a webhook secret mismatch.')
    end

    JSON.parse(event_body)
  end
end
