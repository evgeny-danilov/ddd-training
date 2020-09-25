# frozen_string_literal: true

require_relative 'seat_reservation/events'

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
    load_resource(id) do |resource|
      raise InvalidTransaction unless resource.state == :initialized

      apply_event Events::SeatReserved.new(data: { expired_at: Time.now + 3.hour })
    end
  end

  def create_passenger(params:)
    load_resource(id) do |resource|
      raise InvalidTransaction unless resource.state == :reserved

      Actions::CreatePassenger.new(stream_name: stream_name, params: params[:passenger]).call
      apply_event Events::PassengerDataEntered.new(data: {})
    end
  end

  def paid
    load_resource(id) do |resource|
      raise InvalidTransaction unless resource.state == :passenger_created

      apply_event Events::SeatPaid.new(data: {})
    end
  end

  on Events::SeatReserved do |_event|
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

  def load_resource(id, &block)
    Repository.new.with_id(id, &block)
  end

  def apply_event(event)
    event_store.publish(event, stream_name: stream_name)
  end

  def stream_name
    "SeatReservation$#{id}"
  end

  def event_store
    Rails.configuration.event_store
  end
end
