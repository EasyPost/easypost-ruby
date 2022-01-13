# frozen_string_literal: true

require 'open-uri'
require 'easypost'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.before do
    EasyPost.api_key = ENV['API_KEY']
  end

  config.around do |example|
    # Automaticlaly wrap the test in VCR to avoid forgetting it.
    path = example.file_path.gsub('_spec.rb', '').gsub('./spec/easy_post/', '')
    description = example.full_description
    VCR.use_cassette(
      "#{path}/#{description}",
      example.metadata.fetch(:vcr, {}),
    ) do
      example.call
    end

    # Reset `EasyPost.http_config` to avoid flakey tests.
    EasyPost.reset_http_config
  end
end
