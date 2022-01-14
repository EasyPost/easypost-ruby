# frozen_string_literal: true

require 'vcr'

MATCHERS = {
  uuid: /\h{32}/,
  code: /"code":"[A-Za-z0-9]+"/,
  barcode: /"barcode":"[A-Za-z0-9]+"/,
  created_at: /"created_at":[0-9]{10}/,
  updated_at: /"updated_at":[0-9]{10}/,
  reference: /"reference":"[A-Za-z0-9]+"/,
  date: /"[0-9]{4}-[0-9]{2}-[0-9]{2}"/,
  datetime: /"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}[:|%3A][0-9]{2}[:|%3A][0-9]{2}(\.)?\d*?[+-Z]([0-9]{2}[:|%3A][0-9]{2})?"/, # ruboco:disable Layout/LineLength
}.freeze

VCR.configure do |config|
  def prepare(string)
    MATCHERS.reduce(string.dup) do |str, (name, matcher)|
      str.gsub!(matcher, name.to_s) || str
    end
  end

  def scrubbed_matcher(method)
    proc do |request, other|
      request.send(method) == other.send(method) ||
        prepare(request.send(method)) == prepare(other.send(method))
    end
  end

  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.register_request_matcher :scrubbed_body, &scrubbed_matcher(:body)
  config.register_request_matcher :scrubbed_uri, &scrubbed_matcher(:uri)

  config.default_cassette_options = {
    match_requests_on: [:method, :scrubbed_uri, :scrubbed_body],
    allow_unused_http_interactions: false,
  }

  config.before_record do |interaction|
    if interaction.request.headers['Authorization']
      interaction.request.headers['Authorization'] = '<AUTHORIZATION>'
    end
  end
end
