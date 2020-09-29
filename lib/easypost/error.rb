module EasyPost
  class Error < StandardError
    attr_reader :message
    attr_reader :status
    attr_reader :http_status # deprecated
    attr_reader :http_body
    attr_reader :code
    attr_reader :errors

    def initialize(message = nil, status = nil, code = nil, errors = nil, http_body = nil)
      @message = message
      @status = status
      @http_status = status # deprecated
      @code = code
      @errors = errors
      @http_body = http_body

      super(message)
    end

    def to_s
      "#{code} (#{status}): #{message} #{errors}".strip
    end

    def ==(other)
      other.is_a?(Error) &&
        message == other.message &&
        status == other.status &&
        code == other.code &&
        errors == other.errors
    end
  end
end
