# frozen_string_literal: true

class EasyPost::Errors::EasyPostError < StandardError
  def pretty_print
    message.to_s
  end
end
