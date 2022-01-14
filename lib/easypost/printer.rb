# frozen_string_literal: true

class EasyPost::Printer < EasyPost::Resource
  def job
    response = EasyPost.make_request(
      :get, "#{url}/jobs", @api_key,
    )
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def print(params = {})
    if params.instance_of?(EasyPost::PostageLabel)
      temp = params.clone
      params = {}
      params[:postage_label] = temp
    end

    EasyPost.make_request(
      :post, "#{url}/print_postage_label", @api_key, params,
    )
    true
  rescue StandardError
    false
  end
end
