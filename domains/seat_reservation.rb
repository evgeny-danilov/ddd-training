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
      apply_event Events::SeatReserved.new(data: { id: id, expired_at: Time.now + 3.hour })
    end
  end

  def payment_pending
    load_resource(id) do |resource|
      raise InvalidTransaction unless resource.state == :reserved
      apply_event Events::SeatPaymentPending.new(data: { id: id})
    end
  end

  def paid
    load_resource(id) do |resource|
      raise InvalidTransaction unless resource.state == :payment_pending
      apply_event Events::SeatPaid.new(data: { id: id})
    end
  end

  on Events::SeatReserved do |event|
    @state = :reserved
  end

  on Events::SeatPaymentPending do |event|
    @state = :payment_pending
  end

  on Events::SeatPaid do |event|
    @state = :paid
  end

  private

  def load_resource(id, &block)
    Repository.new.with_id(id, &block)
  end

  def apply_event(event)
    event_store.publish(event, stream_name: "SeatReservation$#{event.data[:id]}")
  end

  def event_store
    RailsEventStore::Client.new
  end


end
