# frozen_string_literal: true

module EasyPost::Hooks
  def self.subscribe(type, name, block)
    subscribers[type][name] = block

    name
  end

  def self.unsubscribe(type, name)
    subscribers[type].delete(name)
  end

  def self.unsubscribe_all(type)
    subscribers.delete(type)
  end

  def self.notify(type, context)
    subscribers[type].each_value { |subscriber| subscriber.call(context) }
  end

  def self.any_subscribers?(type)
    !subscribers[type].empty?
  end

  def self.subscribers
    @subscribers ||= Hash.new { |hash, key| hash[key] = {} }
  end

  private_class_method :subscribers
end

require_relative 'hooks/request_context'
require_relative 'hooks/response_context'
