# frozen_string_literal: true

require_relative 'seat_reservation/events'
require_relative 'seat_reservation/read_model'

class SeatReservation
  include AggregateRoot

  InvalidTransaction = Class.new(StandardError)

  def initialize(id)
    @state = :initialized
    @id = id
  end

  attr_reader :state, :id

  def fetch
    Repository.new.fetch(id)
  end

  def reserve
    raise InvalidTransaction unless resource.state == :initialized

    broadcast(Events::Reserved, expired_at: Time.now + 3.hour)
  end

  def create_passenger(params:)
    raise InvalidTransaction unless resource.state == :reserved

    broadcast(Events::PassengerDataEntered, params: params)
  end

  def paid
    raise InvalidTransaction unless resource.state == :passenger_created

    broadcast(Events::Paid)
  end

  on Events::Reserved do |_event|
    @state = :reserved
  end

  on Events::PassengerDataEntered do |_event|
    @state = :passenger_data_entered
  end

  on Events::PassengerCreated do |_event|
    @state = :passenger_created
  end

  on Events::Paid do |_event|
    @state = :paid
  end

  private

  def resource
    return @resource if defined?(@resource)

    Repository.new.with_id(id) { return @resource = _1 }
  end

  def broadcast(event_class, payload)
    event = event_class.new(data: payload.merge(stream_id: id))
    event.tap { Publisher.broadcast(event) }
  end
end
