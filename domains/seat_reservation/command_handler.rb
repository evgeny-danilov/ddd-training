# frozen_string_literal: true
## frozen_string_literal: true
#
# module SeatReservation
#  class CommandHandler
#
#    def reserve(params:)
#      ActiveRecord::Base.transaction do
#        with_resource(uuid) do |resource|
#          resource.reserve(params: params)
#        end
#      end
#    end
#
#    #def create_passenger(params:)
#    #end
#
#    #def paid(params:)
#    #end
#
#    private
#
#    def with_resource(uuid)
#      AggregateRoots::SeatReservation.new(uuid).tap do |seat_reservation|
#        load_seat_reservation(uuid, seat_reservation)
#        yield(seat_reservation)
#        store_seat_reservation(seat_reservation)
#      end
#    end
#
#    def load_seat_reservation(uuid, seat_reservation)
#      seat_reservation.load(stream_name(uuid), event_store: event_store)
#    end
#
#    def store_seat_reservation(seat_reservation)
#      seat_reservation.store(event_store: event_store)
#    end
#
#    def stream_name(uuid)
#      "SeatReservation$#{uuid}"
#    end
#
#    def event_store
#      Rails.configuration.event_store
#    end
#  end
# end
