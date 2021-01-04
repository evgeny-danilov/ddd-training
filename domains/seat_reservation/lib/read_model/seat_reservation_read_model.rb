# frozen_string_literal: true

module SeatReservation
  module ReadModel
    class SeatReservationReadModel
      class Table < ApplicationRecord
        self.table_name = 'seat_reservations'
      end

      def call(event)
        case event
        when ::SeatReservation::Events::Created
          create_seat_reservation_record(event.data[:params])
        end
      end

      def all
        Table.all
      end

      def build(attributes)
        Table.new(attributes)
      end

      def already_reserved?(number)
        Table.exists?(number: number)
      end

      private

      def create_seat_reservation_record(params)
        Table.create!(params)
      end
    end
  end
end
