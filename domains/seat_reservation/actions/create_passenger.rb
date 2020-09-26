# frozen_string_literal: true

class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_id:, params:)
        @stream_id = stream_id
        @form = Forms::PassengerForm.new(params)
      end

      def call
        passenger = create_passenger
        broadcast_event(passenger)
      end

      private

      attr_reader :form, :stream_id

      def create_passenger
        Entities::Passenger.create(form.attributes)
      end

      def broadcast_event(passenger)
        Publisher.broadcast(
          Events::PassengerCreated.new(data: { stream_id: stream_id, passenger: passenger })
        )
      end
    end
  end
end
