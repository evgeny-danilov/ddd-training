# frozen_string_literal: true

module Flight
  module Events
    class Scheduled < RailsEventStore::Event
      def self.strict(data)
        new(data: { params: data[:params], stream_id: data[:stream_id] })
      end
    end

    class Cancelled < RailsEventStore::Event
      def self.strict(data)
        new(data: { stream_id: data[:stream_id] })
      end
    end
  end
end
