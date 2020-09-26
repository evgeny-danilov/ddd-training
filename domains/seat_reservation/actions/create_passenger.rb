# frozen_string_literal: true

class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_id:, params:)
        @stream_id = stream_id
        @form = Forms::PassengerForm.new(params)
      end

      def call
        validate!
        broadcast_event(passenger: create_passenger)
      end

      private

      attr_reader :form, :validator, :stream_id

      def validate!
        validator = Validators::PassengerFormValidator.new.call(form.attributes)
        return if validator.success?

        raise Core::Forms::Error, validator.error_messages
      end

      def create_passenger
        Entities::Passenger.create!(form.attributes)
      end

      def broadcast_event(passenger:)
        Publisher.broadcast(
          Events::PassengerCreated.new(data: { stream_id: stream_id, passenger: passenger })
        )
      end
    end
  end
end
