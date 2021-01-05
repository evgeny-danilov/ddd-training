# frozen_string_literal: true

module Flight
  module ReadModel
    class FlightReadModel
      class Table < ApplicationRecord
        self.table_name = 'flights'

        belongs_to :route, class_name: 'Route::ReadModel::RouteReadModel::Table'
      end

      def call(event)
        case event
        when ::Flight::Events::Scheduled
          create_flight(event.data[:params])
        when ::Flight::Events::Cancelled
          cancel_flight
        end
      end

      def all
        Table.all
      end

      def build(attributes)
        Table.new(attributes)
      end

      def scheduled?(uuid)
        Table.exists?(uuid: uuid, status: 'scheduled')
      end

      private

      def create_flight(params)
        flight = Table.new(params)
        Command.save(flight)
      end

      def cancel_flight
        # TODO
      end
    end
  end
end
