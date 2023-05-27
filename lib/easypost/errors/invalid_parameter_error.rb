# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Errors::InvalidParameterError < EasyPost::Errors::EasyPostError
  # @param [String] parameter The name of the parameter that was invalid.
  # @param [String] suggestion Optional suggestion message for a valid parameter.
  def initialize(parameter, suggestion = nil)
    super EasyPost::Constants::INVALID_PARAMETER % parameter + (suggestion.nil? ? '' : " #{suggestion}")
  end
end
