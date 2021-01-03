# frozen_string_literal: true

class Publisher

  def self.broadcast(event, stream_name)
    Rails.configuration.event_store.publish(event, stream_name: stream_name)
  end

end
