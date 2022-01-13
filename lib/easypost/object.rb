# frozen_string_literal: true

require 'set'

class EasyPost::EasyPostObject
  include Enumerable

  attr_accessor :parent, :name, :api_key, :unsaved_values

  @@immutable_values = Set.new([:api_key, :id]) # rubocop:disable Style/ClassVars

  def initialize(id = nil, api_key = nil, parent = nil, name = nil)
    @api_key = api_key
    @values = {}
    @unsaved_values = Set.new
    @transient_values = Set.new
    @parent = parent
    @name = name
    self.id = id if id
  end

  def self.construct_from(values, api_key = nil, parent = nil, name = nil)
    obj = new(values[:id], api_key, parent, name)
    obj.refresh_from(values, api_key)
    obj
  end

  def to_s(*_args)
    JSON.dump(@values)
  end

  def inspect
    id_string = respond_to?(:id) && !id.nil? ? " id=#{id}" : ''
    "#<#{self.class}:#{id_string}> JSON: " + to_json
  end

  def refresh_from(values, api_key, _partial = false) # rubocop:disable Style/OptionalBooleanParameter
    @api_key = api_key

    added = Set.new(values.keys - @values.keys)

    instance_eval do
      add_accessors(added)
    end

    values.each do |k, v|
      @values[k.to_s] = EasyPost::Util.convert_to_easypost_object(v, api_key, self, k)
      @transient_values.delete(k)
      @unsaved_values.delete(k)
    end
  end

  def [](key)
    @values[key.to_s]
  end

  def []=(key, value)
    send(:"#{key}=", value)
  end

  def keys
    @values.keys
  end

  def values
    @values.values
  end

  def to_json(_options = {})
    JSON.dump(@values)
  end

  def as_json(_options = {})
    @values.as_json
  end

  def to_hash
    @values
  end

  def deconstruct_keys(_keys)
    @values.transform_keys(&:to_sym)
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
    @unsaved_values.each do |key|
      value = @values[key]

      values[key] = value

      if value.is_a?(EasyPost::EasyPostObject)
        values[key] = flatten_unsaved(value)
      end
    end

    values
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

        k = k.to_s
        k_eq = :"#{k}="
        define_method(k) { @values[k] }
        define_method(k_eq) do |v|
          @values[k] = v
          @unsaved_values.add(k)

          cur = self
          cur_parent = parent
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
