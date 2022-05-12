# frozen_string_literal: true

require 'vcr'
require 'json'

REPLACEMENT_VALUE = '<REDACTED>'
RESPONSE_BODY_SCRUBBERS = %w[
  api_keys
  children
  client_ip
  credentials
  email
  key
  keys
  phone_number
  phone
  test_credentials
].freeze

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.default_cassette_options = {
    match_requests_on: [
      :body,
      :method,
      :uri,
    ],
    allow_unused_http_interactions: false,
  }

  config.before_record do |interaction|
    scrub_request_headers(interaction)
    scrub_response_bodies(interaction)
  end

  def scrub_request_headers(interaction)
    # rubocop:disable Style/GuardClause
    unless interaction.request.headers['Authorization'].nil?
      interaction.request.headers['Authorization'] = REPLACEMENT_VALUE
    end
    unless interaction.request.headers['User-Agent'].nil?
      interaction.request.headers['User-Agent'] = REPLACEMENT_VALUE
    end
    unless interaction.request.headers['X-Client-User-Agent'].nil?
      interaction.request.headers['X-Client-User-Agent'] = REPLACEMENT_VALUE
    end
    # rubocop:enable Style/GuardClause
  end

  # Scrub sensitive data from response bodies (at the root level or in a root list) prior to recording the cassette
  # This DOES NOT scrub data in nested objects or lists
  def scrub_response_bodies(interaction)
    RESPONSE_BODY_SCRUBBERS.each do |scrubber|
      next unless interaction.response.body && !interaction.response.body.empty?

      response_body = JSON.parse(interaction.response.body)

      if response_body.is_a?(Array)
        response_body.each do |element|
          element[scrubber] = REPLACEMENT_VALUE if element.key?(scrubber)
        end
      else
        response_body[scrubber] = REPLACEMENT_VALUE unless response_body[scrubber].nil?
      end

      interaction.response.body = response_body.to_json
    end
  end
end
