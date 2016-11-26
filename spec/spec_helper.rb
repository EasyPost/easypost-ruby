require 'open-uri'
require 'easypost'

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"

  config.before(:each) do
    EasyPost.api_key = 'cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi'
  end
end
