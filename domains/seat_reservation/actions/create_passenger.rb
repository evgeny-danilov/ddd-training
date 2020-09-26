# frozen_string_literal: true

class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_id:, params:)
        @stream_id = stream_id
        @form = Forms::PassengerForm.new(params)
      end

      def call
        create_passenger
        broadcast_event
      end

      private

      attr_reader :form, :stream_id

      def create_passenger
        Entities::Passenger.create(form.attributes)
      end

      def broadcast_event
        Publisher.broadcast(
          Events::PassengerCreated.new(data: { stream_id: stream_id})
        )
      end
    end
  end
end
