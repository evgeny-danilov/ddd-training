# frozen_string_literal: true

class SeatReservation
  module Actions
    class CreatePassenger
      def initialize(stream_name:, params:)
        @stream_name = stream_name
        @form = Forms::PassengerForm.new(params)
      end

      def call
        Entities::Passenger.create(form.attributes)
        passenger_created
      end

      private

      attr_reader :form, :stream_name

      def passenger_created
        event = Events::PassengerCreated.new(data: {})
        Rails.configuration.event_store.publish(event, stream_name: stream_name)
      end
    end
  end
end
