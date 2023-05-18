# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Exceptions::MissingParameterError < EasyPost::Exceptions::EasyPostError
  def initialize(parameter)
    super EasyPost::Constants::ErrorMessages::MISSING_REQUIRED_PARAMETER % parameter
  end
end
