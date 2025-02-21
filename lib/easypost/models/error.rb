# frozen_string_literal: true

# EasyPost Error object.
class EasyPost::Models::Error
  attr_reader :message

  # Initialize a new EasyPost Error
  def initialize(message = nil)
    @message = message
  end
end
