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

  def load
    Repository.new.load(id)
  end

  def reserve
    raise InvalidTransaction unless resource.state == :initialized

    apply_event Events::Reserved.new(data: { expired_at: Time.now + 3.hour })
  end

  def create_passenger(params:)
    raise InvalidTransaction unless resource.state == :reserved

    apply_event Events::PassengerDataEntered.new(data: {
      stream_name: stream_name, 
      params: params
    })
  end

  def paid
    raise InvalidTransaction unless resource.state == :passenger_created

    apply_event Events::SeatPaid.new(data: {})
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

  on Events::SeatPaid do |_event|
    @state = :paid
  end

  private

  def resource
    return @resource if defined?(@resource)

    Repository.new.with_id(id) { return @resource = _1 }
  end

  def apply_event(event)
    event_store.publish(event, stream_name: stream_name)
    event
  end

  def stream_name
    "SeatReservation$#{id}"
  end

  def event_store
    Rails.configuration.event_store
  end
end
