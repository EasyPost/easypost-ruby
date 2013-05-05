module EasyPost
  class Error < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :json_body
    attr_reader :param

    def initialize(message=nil, http_status=nil, http_body=nil, json_body=nil)
      @message = message
      @http_status = http_status
      @http_body = http_body
      @json_body = json_body

      begin
        @param = @json_body[:error][:param]
      rescue
        @param = nil
      end

      super(message)
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end
  end
end
