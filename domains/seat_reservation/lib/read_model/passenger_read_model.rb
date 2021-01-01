# frozen_string_literal: true

module SeatReservation
  module ReadModel
    class PassengerReadModel
      class Table < ApplicationRecord
        self.table_name = 'seat_reservation_passengers'
      end

      def call(event)
        case event
        when ::SeatReservation::Events::PassengerCreated
          create_passenger_record(event.data[:params])
        end
      end

      def all
        Table.all
      end

      def build(attributes)
        Table.new(attributes)
      end

      private

      def create_passenger_record(params)
        Table.create!(params)
      end
    end
  end
end
