# frozen_string_literal: true

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
      EventRepository.new.fetch(id)
    end

    def create(params:)
      raise InvalidTransactionError unless resource.state == :initialized
      raise SeatHasAlreadyReserved if ReadModel::SeatReservationReadModel.new.already_reserved?(params[:number])
      raise FlightIsNotAvailable unless Flight::ReadModel::FlightReadModel.new.scheduled?(params[:flight_uuid])

      broadcast(Events::Created, {
                  params: params,
                  expired_at: Time.now + 3.hour
                })
    end

    def add_passenger(params:)
      raise InvalidTransactionError unless resource.state == :created

      broadcast(Events::PassengerAdded, {
                  params: params
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

    private

    def resource
      return @resource if defined?(@resource)

      EventRepository.new.with_id(id) { return @resource = _1 }
    end

    def broadcast(event_class, payload)
      event = event_class.strict(payload.merge(stream_id: id))
      event.tap { Publisher.broadcast(event, stream_name) }
    end

    def stream_name
      "SeatReservation$#{id}"
    end
  end
end
