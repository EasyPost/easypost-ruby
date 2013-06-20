module EasyPost
  class EasyPostObject
    include Enumerable

    attr_accessor :api_key
    @@immutable_values = Set.new([:api_key, :id])

    def initialize(id=nil, api_key=nil)
      @api_key = api_key
      @values = {}
      @unsaved_values = Set.new
      @transient_values = Set.new
      self.id = id if id
    end

    def self.construct_from(values, api_key=nil)
      obj = self.new(values[:id], api_key)
      obj.refresh_from(values, api_key)
      obj
    end

    def to_s(*args)
      MultiJson.dump(@values, :pretty => true)
    end

    def inspect()
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:#{id_string}> JSON: " + MultiJson.dump(@values, :pretty => true)
    end

    def refresh_from(values, api_key, partial=false)
      @api_key = api_key

      added = Set.new(values.keys - @values.keys)
      
      instance_eval do
        add_accessors(added)
      end
      
      values.each do |k, v|
        @values[k] = Util.convert_to_easypost_object(v, api_key)
        @transient_values.delete(k)
        @unsaved_values.delete(k)
      end
    end

    def [](k)
      k = k.to_sym if k.is_a?(String)
      @values[k]
    end

    def []=(k, v)
      send(:"#{k}=", v)
    end

    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def to_json(options = {})
      MultiJson.dump(@values)
    end

    def as_json(options = {})
      @values.as_json
    end

    def to_hash
      @values
    end

    def each(&blk)
      @values.each(&blk)
    end

    def id=(id)
      @values[:id] = id
    end

    def id
      @values[:id]
    end

    protected

    def metaclass
      class << self; self; end
    end

    def remove_accessors(keys)
      metaclass.instance_eval do
        keys.each do |k|
          next if @@immutable_values.include?(k)
          k_eq = :"#{k}="
          remove_method(k) if method_defined?(k)
          remove_method(k_eq) if method_defined?(k_eq)
        end
      end
    end

    def add_accessors(keys)
      metaclass.instance_eval do
        keys.each do |k|
          next if @@immutable_values.include?(k)
          k_eq = :"#{k}="
          define_method(k) { @values[k] }
          define_method(k_eq) do |v|
            @values[k] = v
            @unsaved_values.add(k)
          end
        end
      end
    end

  end
end
