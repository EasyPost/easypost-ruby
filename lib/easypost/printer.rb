module EasyPost
  class Printer < Resource

    def job
      response = EasyPost.make_request(
        :get, url + '/jobs', @api_key
      )
      return EasyPost::Util::convert_to_easypost_object(response, api_key)
    end

    def print(params={})
      if params.instance_of?(EasyPost::PostageLabel)
        temp = params.clone
        params = {}
        params[:postage_label] = temp
      end

      response = EasyPost.make_request(
        :post, url + '/print_postage_label', @api_key, params
      )
      return true
    rescue
      return false
    end

  end
end

