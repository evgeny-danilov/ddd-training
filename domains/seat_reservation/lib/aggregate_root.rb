# frozen_string_literal: true

require_relative 'events'

module SeatReservation
  class AggregateRoot
    include Core::AggregateRoot

    SeatHasAlreadyReserved = Class.new(StandardError)
    FlightIsNotAvailable = Class.new(StandardError)

    def initialize(id)
      @state = :initialized
      @id = id
    end

    attr_reader :state, :id

    def fetch
      event_repository.fetch(id)
    end

    def create(form:)
      raise InvalidTransactionError unless resource.state == :initialized
      raise SeatHasAlreadyReserved if ReadModel::SeatReservationReadModel.new.already_reserved?(form.number)
      raise FlightIsNotAvailable unless Flight::ReadModel::FlightReadModel.new.scheduled?(form.flight_uuid)

      broadcast(Events::Created, {
                  params: form.attributes,
                  expired_at: Time.now + 3.hour
                })
    end

    def add_passenger(form:)
      raise InvalidTransactionError unless resource.state == :created

      broadcast(Events::PassengerAdded, {
                  params: form.attributes
                })
    end

    def paid
      raise InvalidTransactionError unless resource.state == :passenger_added

      broadcast(Events::Paid, {})
    end

    on Events::Created do |_event|
      @state = :created
    end

    on Events::PassengerAdded do |_event|
      @state = :passenger_added
    end

    on Events::Paid do |_event|
      @state = :paid
    end

    def stream_name
      "SeatReservation$#{id}"
    end

    private

    def resource
      return @resource if defined?(@resource)

      event_repository.with_id(id) { return @resource = _1 }
    end

    def broadcast(event_class, payload)
      event = event_class.strict(payload.merge(stream_id: id))
      event.tap { Publisher.broadcast(event, stream_name) }
    end

    def event_repository
      EventRepository.new(aggregate_root_class: self.class)
    end
  end
end
