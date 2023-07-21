# frozen_string_literal: true

module EasyPost::Hooks
  def self.subscribers
    @subscribers ||= Hash.new { |hash, key| hash[key] = {} }
  end

  def self.subscribe(type, name=rand, &block)
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

  private_class_method :subscribers
end
