# frozen_string_literal: true

module SeatReservation
  module ReadModel
    class SeatReservationReadModel
      class SeatReservationAR < ApplicationRecord
        self.table_name = 'seat_reservations'
      end

      def call(event)
        case event
        when ::SeatReservation::Events::Reserved
          create_seat_reservation_record(event.data[:params])
        end
      end

      def all
        SeatReservationAR.all
      end

      def build(attributes)
        SeatReservationAR.new(attributes)
      end

      def already_reserved?(number)
        SeatReservationAR.exists?(number)
      end

      private

      def create_seat_reservation_record(params)
        SeatReservationAR.create!(params)
      end
    end
  end
end
