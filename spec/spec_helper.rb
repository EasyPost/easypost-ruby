require 'open-uri'
require 'easypost'

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    EasyPost.api_key = 'BmvaWhg8mP26QXWdTplYWA'
  end

  config.around(:each) do |example|
    # Save the original `http_config` in case the test mutates it.
    http_config = EasyPost.http_config

    # Automaticlaly wrap the test in VCR to avoid forgetting it.
    path = example.file_path.gsub("_spec.rb", "").gsub("./spec/", "")
    description = example.full_description
    VCR.use_cassette(
      "#{path}/#{description}",
      example.metadata.fetch(:vcr, {})
    ) do
      example.call
    end

    # Reset `EasyPost.http_config` to avoid flakey tests.
    EasyPost.reset_http_config
  end
end
