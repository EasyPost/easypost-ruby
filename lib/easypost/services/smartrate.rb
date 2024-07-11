class EasyPost::Services::SmartRate < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::SmartRate

  # Retrieve the estimated delivery date of each carrier-service level combination via the
  # Smart Deliver By API, based on a specific ship date and origin-destination postal code pair.
  def estimate_delivery_date(params = {})
    url = 'smartrate/deliver_by'

    response = @client.make_request(:post, url, params)
    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a recommended ship date for each carrier-service level combination via the
  # Smart Deliver On API, based on a specific delivery date and origin-destination postal code pair.
  def recommend_ship_date(params = {})
    url = 'smartrate/deliver_on'

    response = @client.make_request(:post, url, params)
    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
