# frozen_string_literal: true

class SeatReservation
  class EventRepository
    def initialize(event_store = Rails.configuration.event_store)
      @repository = AggregateRoot::Repository.new(event_store)
    end

    def with_id(id, &block)
      repository.with_aggregate(domain_object(id), stream_name(id), &block)
    end

    def fetch(id)
      repository.load(domain_object(id), stream_name(id))
    end

    private

    attr_reader :repository

    def domain_object(id)
      SeatReservation.new(id)
    end

    def stream_name(id)
      raise ArgumentError unless id.class.in? [Integer, String]

      "SeatReservation$#{id}"
    end
  end
end
