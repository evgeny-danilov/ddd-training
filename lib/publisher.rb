# frozen_string_literal: true

class Publisher
  def self.broadcast(event)
    new(event).broadcast
  end

  def initialize(event)
    @event = event
  end

  def broadcast
    Rails.configuration.event_store.publish(event, stream_name: stream_name)
  end

  private

  attr_reader :event

  def stream_name
    "#{stream_prefix}$#{stream_id}"
  end

  def stream_id
    event.data[:stream_id]
  end

  def stream_prefix
    event.class.to_s.split('::').first
  end
end
