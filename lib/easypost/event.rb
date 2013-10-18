module EasyPost
  class Event < Resource
	def receive(values)
		self.refresh_from(values, @api_key, true)
		return self
	end
 
  end
end
