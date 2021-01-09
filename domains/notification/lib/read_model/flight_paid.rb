# frozen_string_literal: true

## This example relates to `Saga` / `Process Manager approach
##
## Let's imagine these is something like
## event_store.subscribe(Notification::ReadModel::FlightCancelled.new, to: [
##   SeatReservation::Events::PassengerAdded,
##   SeatReservation::Events::Paid
## ])
##
## and we want to execute some action when both events are happened,
##  but don't have a `stream_id` in one of this event (`Events::Paid` for instance).
##
## The approach below might be useful in this case.
#
# module Notification
#  module ReadModel
#    class FlightCancelled
#      def call(event)
#        event_store.link(event.event_id, stream_name: stream_for(event))
#
#        state = build_state(stream_for(event))
#
#        execute(state) if state[:order_placed] && state[:payment_captured]
#      end
#      private
#
#      def event_store
#        Rails.configuration.event_store
#      end
#
#      def stream_for(event)
#        "SeatReservation^#{event.data[:stream_id]}"
#      end
#
#      def build_state(stream_name)
#        RailsEventStore::Projection
#          .from_stream(stream_name)
#          .init(-> { {} })
#          .when(SeatReservation::Events::PassengerAdded, -> (state, event) {
#            state[:order_placed] = true
#            state[:stream_id] = event.data[:stream_id]
#          })
#          .when(SeatReservation::Events::Paid, -> (state, _event) {
#            state[:payment_captured] = true
#          })
#          .run(event_store)
#      end
#
#      def execute(state)
#        AdminMailer.payment_paid(state[:stream_id]).deliver_later
#      end
#    end
#  end
# end
