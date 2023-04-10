# frozen_string_literal: true

# The base class for all services in the library.
class EasyPost::Services::Service
  def initialize(client)
    @client = client
  end
end
