require "set"

module EasyPost
  class EasyPostObject
    include Enumerable

    attr_accessor :parent, :name, :api_key, :unsaved_values
    @@immutable_values = Set.new([:api_key, :id])

    def initialize(id=nil, api_key=nil, parent=nil, name=nil)
      @api_key = api_key
      @values = {}
      @unsaved_values = Set.new
      @transient_values = Set.new
      @parent = parent
      @name = name
      self.id = id if id
    end

    def self.construct_from(values, api_key=nil, parent=nil, name=nil)
      obj = self.new(values[:id], api_key, parent, name)
      obj.refresh_from(values, api_key)
      obj
    end

    def to_s(*args)
      JSON.dump(@values)
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:#{id_string}> JSON: " + to_json
    end

    def refresh_from(values, api_key, partial=false)
      @api_key = api_key

      added = Set.new(values.keys - @values.keys)

      instance_eval do
        add_accessors(added)
      end

      values.each do |k, v|
        @values[k.to_s] = Util.convert_to_easypost_object(v, api_key, self, k)
        @transient_values.delete(k)
        @unsaved_values.delete(k)
      end
    end

    def [](k)
      @values[k.to_s]
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
      JSON.dump(@values)
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

    def flatten_unsaved
      values = {}
      for key in @unsaved_values
        value = @values[key]

        values[key] = value

        if value.is_a?(EasyPost::EasyPostObject)
          values[key] = flatten_unsaved(value)
        end
      end

      return values
    end

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

            cur = self
            cur_parent = self.parent
            param = {}
            while cur_parent
              if cur.name
                cur_parent.unsaved_values.add(cur.name)
              end

              cur = cur_parent
              cur_parent = cur.parent
            end
          end
        end
      end
    end
  end
end
