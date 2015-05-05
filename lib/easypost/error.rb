module EasyPost
  class Error < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :json_body
    attr_reader :param
    attr_reader :code
    attr_reader :errors

    def initialize(message=nil, http_status=nil, http_body=nil, json_body={})
      @message = message
      @http_status = http_status
      @http_body = http_body
      @json_body = json_body

      if (error = @json_body.fetch(:error, {})).is_a?(Hash)
        @param  = error.fetch(:param, nil)
        @code   = error.fetch(:code, nil)
        @errors = error.fetch(:errors, nil)
      end

      super(message)
    end

    def to_s
      s = "#{@code} (#{@http_status}): #{@message}";
      if @errors
          s += "\nField errors:\n"
          @errors.each do |field_error|
            field_error.each do |k, v|
              s += "  #{k}: #{v}\n"
            end
            s += "\n"
          end
      end
      s
    end
  end
end

