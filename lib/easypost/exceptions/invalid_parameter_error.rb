# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Exceptions::InvalidParameterError < EasyPost::Exceptions::EasyPostError
  def initialize(parameter, tip = nil)
    super EasyPost::Constants::INVALID_PARAMETER % parameter + (tip.nil? ? '' : tip)
  end
end
