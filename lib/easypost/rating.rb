module EasyPost
  class Rating < Resource
  	def self.create(params={}, api_key=nil)
      unique_url = "/rating/v1/rates"
      response, api_key = EasyPost.request(:post, unique_url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
  	end
  end
end