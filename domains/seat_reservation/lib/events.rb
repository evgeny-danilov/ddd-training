# frozen_string_literal: true

module SeatReservation
  module Events
    class Reserved < RailsEventStore::Event
      def self.strict(data)
        params = Attributes::SeatReservationAttributes.new(params: data[:params]).call
        new(data: { params: params, stream_id: data[:stream_id] })
      end
    end

    class PassengerCreated < RailsEventStore::Event
      def self.strict(data)
        params = Attributes::PassengerAttributes.new(params: data[:params]).call
        new(data: { params: params, stream_id: data[:stream_id] })
      end
    end

    class Paid < RailsEventStore::Event
      def self.strict(data)
        new(data: { params: nil, stream_id: data[:stream_id] })
      end
    end
  end
end
