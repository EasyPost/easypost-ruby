# frozen_string_literal: true

# Simplecov must be loaded before everything else to work properly
require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter,
  ],
)

SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter '/spec/'
  add_filter 'lib/easypost/version.rb'
  enable_coverage :branch
  minimum_coverage 94
end

require 'open-uri'
require 'easypost'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.around do |example|
    # Automatically wrap the test in VCR to avoid forgetting it.
    path = example.file_path.gsub('_spec.rb', '').gsub('./spec/', '')
    description = example.full_description
    cassette_path = "#{path}/#{description}"
    VCR.use_cassette(
      cassette_path,
      allow_unused_http_interactions: true,
    ) do
      example.call
    end

    check_expired_cassette(cassette_path)

    # Reset `EasyPost.http_config` to avoid flakey tests.
    EasyPost.reset_http_config
  end
end

# Checks for an expired cassette and warns if it is too old and must be re-recorded
def check_expired_cassette(cassette_path)
  full_cassette_path = "#{"spec/cassettes/#{cassette_path}".gsub('::', '_').gsub(' ', '_').gsub('.', '_')}.yml"
  seconds_in_day = 86_400
  expiration_days = 180
  expiration_seconds = seconds_in_day * expiration_days

  return unless File.exist?(full_cassette_path)

  cassette_timestamp = File.mtime(full_cassette_path)
  expiration_timestamp = DateTime.parse((cassette_timestamp + expiration_seconds).to_s)
  current_timestamp = DateTime.now

  return unless current_timestamp > expiration_timestamp

  warn "#{full_cassette_path} is older than #{expiration_days} days and has expired. Please re-record the cassette"
end
