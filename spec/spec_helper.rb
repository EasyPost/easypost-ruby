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
    VCR.use_cassette(
      "#{path}/#{description}",
      allow_unused_http_interactions: true,
    ) do
      example.call
    end

    # Reset `EasyPost.http_config` to avoid flakey tests.
    EasyPost.reset_http_config
  end
end
