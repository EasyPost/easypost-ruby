require 'open-uri'
require 'easypost'

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    EasyPost.api_key = 'BmvaWhg8mP26QXWdTplYWA'
  end

  config.around(:each) do |example|
    path = example.file_path.gsub("_spec.rb", "").gsub("./spec/", "")
    description = example.full_description

    VCR.use_cassette(
      "#{path}/#{description}",
      example.metadata.fetch(:vcr, {})
    ) do
      example.call
    end
  end
end
