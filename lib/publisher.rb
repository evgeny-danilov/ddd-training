# frozen_string_literal: true

class Publisher
  def self.broadcast(event, stream_name)
    new(event, stream_name).broadcast
  end

  def initialize(event, stream_name)
    @event = event
    @stream_name = stream_name
  end

  def broadcast
    Rails.configuration.event_store.publish(event, stream_name: stream_name)
  end

  private

  attr_reader :event, :stream_name
end
