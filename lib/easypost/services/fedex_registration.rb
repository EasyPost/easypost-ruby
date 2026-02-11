# frozen_string_literal: true

require 'securerandom'

class EasyPost::Services::FedexRegistration < EasyPost::Services::Service
  # Register the billing address for a FedEx account.
  # Advanced method for custom parameter structures.
  #
  # @param fedex_account_number [String] The FedEx account number.
  # @param params [Hash] Map of parameters.
  # @return [EasyPost::Models::FedExAccountValidationResponse] object with next steps (PIN or invoice validation).
  def register_address(fedex_account_number, params = {})
    wrapped_params = wrap_address_validation(params)
    endpoint = "fedex_registrations/#{fedex_account_number}/address"

    response = @client.make_request(:post, endpoint, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::FedExAccountValidationResponse)
  end

  # Request a PIN for FedEx account verification.
  #
  # @param fedex_account_number [String] The FedEx account number.
  # @param pin_method_option [String] The PIN delivery method: "SMS", "CALL", or "EMAIL".
  # @return [EasyPost::Models::FedExRequestPinResponse] object confirming PIN was sent.
  def request_pin(fedex_account_number, pin_method_option)
    wrapped_params = {
      pin_method: {
        option: pin_method_option,
      },
    }
    endpoint = "fedex_registrations/#{fedex_account_number}/pin"

    response = @client.make_request(:post, endpoint, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::FedExRequestPinResponse)
  end

  # Validate the PIN entered by the user for FedEx account verification.
  #
  # @param fedex_account_number [String] The FedEx account number.
  # @param params [Hash] Map of parameters.
  # @return [EasyPost::Models::FedExAccountValidationResponse] object.
  def validate_pin(fedex_account_number, params = {})
    wrapped_params = wrap_pin_validation(params)
    endpoint = "fedex_registrations/#{fedex_account_number}/pin/validate"

    response = @client.make_request(:post, endpoint, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::FedExAccountValidationResponse)
  end

  # Submit invoice information to complete FedEx account registration.
  #
  # @param fedex_account_number [String] The FedEx account number.
  # @param params [Hash] Map of parameters.
  # @return [EasyPost::Models::FedExAccountValidationResponse] object.
  def submit_invoice(fedex_account_number, params = {})
    wrapped_params = wrap_invoice_validation(params)
    endpoint = "fedex_registrations/#{fedex_account_number}/invoice"

    response = @client.make_request(:post, endpoint, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::FedExAccountValidationResponse)
  end

  private

  # Wraps address validation parameters and ensures the "name" field exists.
  # If not present, generates a UUID (with hyphens removed) as the name.
  #
  # @param params [Hash] The original parameters hash.
  # @return [Hash] A new hash with properly wrapped address_validation and easypost_details.
  def wrap_address_validation(params)
    wrapped_params = {}

    if params.key?(:address_validation)
      address_validation = params[:address_validation].dup
      ensure_name_field(address_validation)
      wrapped_params[:address_validation] = address_validation
    end

    wrapped_params[:easypost_details] = params[:easypost_details] if params.key?(:easypost_details)

    wrapped_params
  end

  # Wraps PIN validation parameters and ensures the "name" field exists.
  # If not present, generates a UUID (with hyphens removed) as the name.
  #
  # @param params [Hash] The original parameters hash.
  # @return [Hash] A new hash with properly wrapped pin_validation and easypost_details.
  def wrap_pin_validation(params)
    wrapped_params = {}

    if params.key?(:pin_validation)
      pin_validation = params[:pin_validation].dup
      ensure_name_field(pin_validation)
      wrapped_params[:pin_validation] = pin_validation
    end

    wrapped_params[:easypost_details] = params[:easypost_details] if params.key?(:easypost_details)

    wrapped_params
  end

  # Wraps invoice validation parameters and ensures the "name" field exists.
  # If not present, generates a UUID (with hyphens removed) as the name.
  #
  # @param params [Hash] The original parameters hash.
  # @return [Hash] A new hash with properly wrapped invoice_validation and easypost_details.
  def wrap_invoice_validation(params)
    wrapped_params = {}

    if params.key?(:invoice_validation)
      invoice_validation = params[:invoice_validation].dup
      ensure_name_field(invoice_validation)
      wrapped_params[:invoice_validation] = invoice_validation
    end

    wrapped_params[:easypost_details] = params[:easypost_details] if params.key?(:easypost_details)

    wrapped_params
  end

  # Ensures the "name" field exists in the provided hash.
  # If not present, generates a UUID (with hyphens removed) as the name.
  # This follows the pattern used in the web UI implementation.
  #
  # @param hash [Hash] The hash to ensure the "name" field in.
  def ensure_name_field(hash)
    return if hash.key?(:name) && !hash[:name].nil?

    uuid = SecureRandom.uuid.delete('-')
    hash[:name] = uuid
  end
end
