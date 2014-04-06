class Notifier
  include Enumerable

  def self.call(events)
    events.each do |event|
      new(event).call
    end
  end

  def initialize(event)
    @event = event
  end

  def each(&block)
    subscriptions.find_each(&block)
  end

  def call
    each do |subscription|
      send_message(subscription.phone, @event.message)
    end
  end

  def send_message(phone, body)
  end

  def subscriptions(&block)
    Subscription.contains(latitude: @event.latitude, longitude: @event.longitude)
  end
end