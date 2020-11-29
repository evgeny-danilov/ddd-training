# frozen_string_literal: true

module Flight
  module Events
    class Scheduled < RailsEventStore::Event
      def self.strict(data)
        params = Attributes::FlightAttributes.new(params: data[:params]).call
        new(data: { params: params, stream_id: data[:stream_id] })
      end
    end

    class Cancelled < RailsEventStore::Event
      def self.strict(data)
        new(data: { stream_id: data[:stream_id] })
      end
    end
  end
end
