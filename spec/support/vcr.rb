# frozen_string_literal: true

require 'vcr'
require 'json'

REPLACEMENT_STRING = '<REDACTED>'
REPLACEMENT_ARRAY = [].freeze
REPLACEMENT_HASH = {}.freeze

SCRUBBERS = [
  ['api_keys', REPLACEMENT_ARRAY],
  ['client_ip', REPLACEMENT_STRING],
  ['credentials', REPLACEMENT_HASH],
  ['email', REPLACEMENT_STRING],
  ['fields', REPLACEMENT_ARRAY],
  ['key', REPLACEMENT_STRING],
  ['keys', REPLACEMENT_ARRAY],
  ['phone', REPLACEMENT_STRING],
  ['phone_number', REPLACEMENT_STRING],
  ['test_credentials', REPLACEMENT_HASH],
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

  config.filter_sensitive_data(REPLACEMENT_STRING) { Fixture.credit_card_details['number'] }
  config.filter_sensitive_data(REPLACEMENT_STRING) { Fixture.credit_card_details['cvc'] }

  config.before_record do |interaction|
    scrub_request_headers(interaction)
    scrub_response_bodies(interaction)
  end

  def scrub_request_headers(interaction)
    # rubocop:disable Style/GuardClause
    unless interaction.request.headers['Authorization'].nil?
      interaction.request.headers['Authorization'] = REPLACEMENT_STRING
    end
    unless interaction.request.headers['User-Agent'].nil?
      interaction.request.headers['User-Agent'] = REPLACEMENT_STRING
    end
    # rubocop:enable Style/GuardClause
  end

  # Scrub sensitive data from response bodies (at the root level or in a root list) prior to recording the cassette
  # This DOES NOT scrub data in nested objects or lists
  def scrub_response_bodies(interaction)
    SCRUBBERS.each do |scrubber|
      next unless interaction.response.body && !interaction.response.body.empty?

      response_body = JSON.parse(interaction.response.body)

      scrub_data(response_body, scrubber)

      interaction.response.body = response_body.to_json
    end
  end

  private

  def scrub_data(data, scrubber)
    key = scrubber[0]
    replacement = scrubber[1]

    # Root-level list scrubbing
    case data
    when Array
      data.each do |item|
        if item.key?(key)
          item[key] = replacement
        end
      end
    when Hash
      # Root-level key scrubbing
      if data.key?(key)
        data[key] = replacement
      else
        # Nested scrubbing
        data.each do |_top_item, top_values|
          case top_values
          when Array
            top_values.each do |nested_item, _nested_index|
              scrub_data(nested_item, scrubber)
            end
          when Hash
            scrub_data(top_values, scrubber)
          end
        end
      end
    end

    data
  end
end
