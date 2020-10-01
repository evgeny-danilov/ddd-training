# frozen_string_literal: true

module SeatReservation
  module ReadModel
    class Subscribers
      def call(event)
        case event
        when SeatReservation::Events::Reserved
          seat_reserved(event.data)
        when SeatReservation::Events::PassengerDataEntered
          passenger_data_entered(event.data)
        end
      end

      private

      def seat_reserved(payload)
        Actions::CreateSeatReservation.new(payload).call
      end

      def passenger_data_entered(payload)
        Actions::CreatePassenger.new(payload).call
      end
    end
  end
end
