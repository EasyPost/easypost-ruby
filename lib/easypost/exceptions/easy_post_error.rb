# frozen_string_literal: true

class EasyPost::Exceptions::EasyPostError < StandardError
  def initialize(message)
    super message
  end
  def pretty_print
    message.to_s
  end
end
