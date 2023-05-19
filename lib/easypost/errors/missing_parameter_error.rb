# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Errors::MissingParameterError < EasyPost::Errors::EasyPostError
  def initialize(parameter)
    super EasyPost::Constants::MISSING_REQUIRED_PARAMETER % parameter
  end
end
