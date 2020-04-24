require 'open-uri'
require 'easypost'

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    EasyPost.api_key = 'BmvaWhg8mP26QXWdTplYWA'
  end
end
