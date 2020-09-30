class EasyPost::Batch < EasyPost::Resource
  def self.create_and_buy(params={}, api_key=nil)
    wrapped_params = {}
    wrapped_params[self.class_name().to_sym] = params
    response = EasyPost.make_request(:post, url + '/create_and_buy', api_key, wrapped_params)

    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def buy(params={})
    response = EasyPost.make_request(:post, url + '/buy', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def label(params={})
    response = EasyPost.make_request(:post, url + '/label', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def remove_shipments(params={})
    response = EasyPost.make_request(:post, url + '/remove_shipments', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def add_shipments(params={})
    response = EasyPost.make_request(:post, url + '/add_shipments', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def stamp_and_barcode_by_reference(params={})
    response = EasyPost.make_request(:get, url + '/stamp_and_barcode_by_reference', @api_key, params)

    return response
  end

  def create_scan_form(params={})
    response = EasyPost.make_request(:post, url + '/scan_form', @api_key, params)

    return response
  end
end
